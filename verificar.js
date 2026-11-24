/* Valida o banco de questões de um simulado antes de publicar.
   Uso:  node verificar.js simulado.html
   Sai com código 1 se algo estiver errado. */
const fs = require('fs');

const arquivo = process.argv[2] || 'simulado.html';
let src;
try { src = fs.readFileSync(arquivo, 'utf8'); }
catch (e) { console.error('ERRO: nao consegui ler ' + arquivo); process.exit(1); }

/* extrai "const NOME = [ ... ]" com balanceamento de colchetes,
   respeitando strings (para nao quebrar em "]" dentro de texto) */
function extrairLiteral(nome) {
  const key = 'const ' + nome + ' =';
  const i = src.indexOf(key);
  if (i < 0) return null;
  // aceita array [ ... ] ou objeto { ... }
  let j = i + key.length;
  while (j < src.length && /\s/.test(src[j])) j++;
  const abre = src[j];
  if (abre !== '[' && abre !== '{') return null;
  const fecha = abre === '[' ? ']' : '}';
  let depth = 0, str = null, esc = false;
  for (let k = j; k < src.length; k++) {
    const c = src[k];
    if (str) {
      if (esc) { esc = false; continue; }
      if (c === '\\') { esc = true; continue; }
      if (c === str) str = null;
      continue;
    }
    if (c === '"' || c === "'" || c === '`') { str = c; continue; }
    if (c === abre) depth++;
    else if (c === fecha) { depth--; if (depth === 0) return src.slice(j, k + 1); }
  }
  return null;
}

function carregar(nome) {
  const bruto = extrairLiteral(nome);
  if (!bruto) return null;
  try { return eval('(' + bruto + ')'); }
  catch (e) { console.error('ERRO: o array ' + nome + ' nao e JavaScript valido: ' + e.message); return null; }
}

const Q = carregar('QUESTIONS');
if (!Q) { console.error('ERRO: nao achei "const QUESTIONS = [...]" em ' + arquivo); process.exit(1); }
if (!Q.length) { console.error('ERRO: QUESTIONS esta vazio.'); process.exit(1); }

const erros = [];
const avisos = [];
const temas = {};

Q.forEach((q, i) => {
  const n = i + 1;
  const rot = 'Q' + n;

  if (!q.tema || !String(q.tema).trim()) erros.push(rot + ': falta "tema".');
  if (!q.enunciado || String(q.enunciado).trim().length < 15) erros.push(rot + ': "enunciado" vazio ou curto demais.');
  if (!q.conceito || String(q.conceito).trim().length < 40) erros.push(rot + ': falta "conceito" (o resumo que explica a regra).');

  const alts = q.alternativas;
  if (!Array.isArray(alts)) { erros.push(rot + ': falta "alternativas".'); return; }
  if (alts.length !== 5) avisos.push(rot + ': tem ' + alts.length + ' alternativas (o padrao e 5).');

  const corretas = alts.filter(a => a && a.ok === true).length;
  if (corretas !== 1) erros.push(rot + ': tem ' + corretas + ' alternativas corretas (precisa ser exatamente 1).');

  alts.forEach((a, j) => {
    const letra = 'abcde'[j] || String(j);
    if (!a || !a.t || !String(a.t).trim()) erros.push(rot + letra + ': alternativa sem texto.');
    if (!a || !a.porque || String(a.porque).trim().length < 25)
      erros.push(rot + letra + ': falta "porque" explicando o erro (minimo 25 caracteres).');
  });

  temas[q.tema] = (temas[q.tema] || 0) + 1;

  // aula do assunto, se o simulado tiver esse recurso
  if ('licao' in q && (!q.licao || typeof q.licao !== 'string'))
    erros.push(rot + ': campo "licao" presente mas invalido.');
});

/* aulas: se existir LICOES, conferir que toda questao aponta para uma existente */
const L = carregar('LICOES');
let aulas = null;
if (L) {
  aulas = Object.keys(L);
  Q.forEach((q, i) => {
    if (q.licao && !L[q.licao]) erros.push('Q' + (i + 1) + ': aponta para a aula "' + q.licao + '", que nao existe em LICOES.');
  });
  aulas.forEach(id => {
    const a = L[id];
    if (!a.titulo || !a.resumo) erros.push('aula "' + id + '": falta titulo ou resumo.');
    if (!Array.isArray(a.blocos) || !a.blocos.length) erros.push('aula "' + id + '": falta blocos de conteudo.');
  });
}

/* enunciados repetidos */
const vistos = {};
Q.forEach((q, i) => {
  const k = String(q.enunciado || '').replace(/\s+/g, ' ').trim().toLowerCase();
  if (k && vistos[k] !== undefined) erros.push('Q' + (i + 1) + ': enunciado repetido (igual a Q' + (vistos[k] + 1) + ').');
  else vistos[k] = i;
});

/* distribuicao do gabarito como esta escrito no arquivo */
const dist = { a: 0, b: 0, c: 0, d: 0, e: 0 };
Q.forEach(q => { const p = (q.alternativas || []).findIndex(a => a.ok); if (p >= 0) dist['abcde'[p]]++; });
const maxLetra = Math.max(...Object.values(dist));
if (Q.length >= 10 && maxLetra === Q.length) avisos.push('TODAS as corretas estao na letra "' + Object.keys(dist).find(k => dist[k] === maxLetra) + '" no arquivo. O embaralhamento resolve isso em tempo de execucao, mas confira se ele esta ativo.');

/* ---------- relatorio ---------- */
console.log('');
console.log('  Arquivo:     ' + arquivo);
console.log('  Questoes:    ' + Q.length);
if (aulas) console.log('  Aulas:       ' + aulas.length);
console.log('  Temas:       ' + Object.keys(temas).length);
Object.entries(temas).forEach(([t, n]) => console.log('     - ' + t + ': ' + n));
console.log('  Gabarito no arquivo: ' + Object.entries(dist).map(([k, v]) => k + '=' + v).join('  '));
console.log('');

if (avisos.length) {
  console.log('  AVISOS (' + avisos.length + '):');
  avisos.forEach(a => console.log('   ! ' + a));
  console.log('');
}

if (erros.length) {
  console.log('  ERROS (' + erros.length + ') — corrija antes de publicar:');
  erros.forEach(e => console.log('   x ' + e));
  console.log('');
  process.exit(1);
}

console.log('  OK: banco de questoes valido. Pode publicar.');
console.log('');
