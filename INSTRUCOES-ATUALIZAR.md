# Instruções: atualizar o simulado de Química Orgânica

Documento para outra IA (ou qualquer pessoa) executar a atualização.
Leia inteiro antes de tocar em qualquer arquivo. Cada passo é verificável.

---

## 0. Objetivo

Levar o simulado de **Química Orgânica** ao mesmo padrão do de **Física**, que já está pronto e
publicado — ele serve de **modelo de referência** para tudo aqui.

Três tarefas, nesta ordem:

1. **Auditoria** das 26 questões (gabarito, redação, alternativas).
2. **Figuras** SVG nas questões onde a estrutura química importa.
3. **Botão "Aprender o assunto do zero"** + aulas em modal, e publicar.

---

## 1. Onde está cada coisa

| Papel | Caminho |
|---|---|
| **Arquivo a editar** | `C:\Users\jcarlos\Documents\simulado-organica\simulado.html` |
| Cópia publicada (gerada, **não editar**) | `...\simulado-organica\index.html` |
| Validador | `...\simulado-organica\verificar.js` |
| Script de publicação | `...\simulado-organica\publicar.sh` |
| **MODELO — simulado de Física com tudo pronto** | `C:\Users\jcarlos\Documents\simulado-fisica\saida\simulado-com-figuras.html` |
| Instruções de publicação (genéricas) | `...\simulado-fisica\INSTRUCOES-PUBLICAR.md` |
| Link atual | https://maximojota-hue.github.io/simulado-organica/ |
| Repositório | https://github.com/maximojota-hue/simulado-organica (branch `main`) |

**Estado atual do de Química:** 26 questões, 68.400 bytes. Já tem cronômetro de 50 min,
confirmação antes de revelar, gabarito comentado e registro de tentativas.
**Não tem:** aulas (`LICOES`), botão de aula, nem figuras.

---

## 2. Regras invioláveis

1. **Edite só `simulado.html`.** Nunca `index.html` à mão — ele é sobrescrito a cada publicação.
2. **Nunca copie o `simulado.html` inteiro do Física para a pasta de Química.** Isso já corrompeu
   a pasta de Química uma vez. Copie **apenas os blocos** indicados na seção 5.
3. **Não mude gabaritos** (`ok: true`) na etapa de figuras/aulas. Só na auditoria, e só se estiver
   comprovadamente errado — registre cada mudança.
4. **Nenhuma imagem externa.** Todo diagrama é SVG inline. Sem CDN, sem `<img src>`, sem fonte
   externa. O arquivo tem de abrir offline.
5. **Não gere diagrama por IA de imagem.** Ela erra ligações, ângulos e rótulos de química. Use SVG
   escrito à mão (seção 6).
6. Rode o validador antes de cada publicação. Ele é o que pega erro antes do aluno ver.

---

## 3. TAREFA 1 — Auditoria das questões

Corrija o arquivo `simulado.html`. O banco está em `const QUESTIONS = [...]`.

### 3.1 Validação automática (roda primeiro)

```bash
cd "C:/Users/jcarlos/Documents/simulado-organica"
node verificar.js simulado.html
```

O validador cobra: exatamente **1** `ok:true` por questão, `porque` ≥25 caracteres em **todas** as
alternativas, `tema` e `conceito` presentes, e enunciados não repetidos.
Um aviso esperado: `TODAS as corretas estao na letra "a" no arquivo` — isso é normal, o código
embaralha em tempo de execução. **Não "conserte" isso reordenando na mão.** Só confirme que
`montarQuiz()` continua existindo e sendo chamada.

### 3.2 Auditoria de conteúdo (uma questão por vez)

Para cada uma das 26 questões, confira a química:

| Verificar | O que fazer se estiver errado |
|---|---|
| A alternativa `ok:true` está **realmente** correta? | Corrigir movendo `ok:true` para a certa |
| Cada `porque` descreve um erro **real** e específico? | Reescrever citando o conceito errado |
| `conceito` explica a regra que resolve a questão? | Reescrever com a regra geral |
| A questão dá para responder **só com o enunciado**? | Reescrever o enunciado |
| `estrutura` está na notação certa (subscritos reais)? | Corrigir |

**Pontos de atenção específicos deste banco de Química** (numeração conferida no arquivo):

- **Q10 (citral)**: a cadeia é **homogênea** porque o O está no aldeído, **fora** da cadeia.
  Erro clássico: marcar heterogênea.
- **Q15 e Q16 (testosterona)**: 4 carbonos terciários, 2 quaternários; fórmula **C₁₉H₂₈O₂**.
- **Q6 e Q7 (2,2,4-trimetilpentano)**: 5 primários, 1 secundário, 1 terciário, 1 quaternário
  (total 8 carbonos).
- **Q13 (heterogênea × homogênea)**: éter é heterogêneo (O **entre** carbonos); álcool, aldeído e
  ácido são homogêneos (O na ponta).
- **Q22 a Q25 (radicais)**: metil, isopropila, terc-butila e radicais na estrutura — conferir cada
  valência livre.
- **Q26 (3-etil-2,4-dimetilpentano)**: 3 carbonos terciários (C2, C3, C4).

Se achar erro, corrija e **anote** (número da questão + o que mudou) para o relatório final.

---

## 4. TAREFA 2 — Figuras SVG

### 4.1 Quais questões precisam de figura

Prioridade (a estrutura é indispensável para entender):

Numeração conferida no arquivo. As que já têm campo `estrutura` (texto) são as que mais
ganham com um desenho:

| Questão | Tema | Figura sugerida | Prioridade |
|---|---|---|---|
| **15** | Testosterona | 3 anéis de 6 + 1 de 5 condensados, C=O no C3, OH no C17, metilas em C10/C13 | **alta** |
| **10** | Citral | cadeia com as 2 duplas e as 2 metilas, aldeído na ponta | **alta** |
| **6, 7** | 2,2,4-trimetilpentano | esqueleto com C(CH₃)₂ no C2 e CH₃ no C4 | **alta** |
| **8** | metilpropano (isobutano) | esqueleto em Y, carbono central terciário | média |
| **12** | benzeno | anel com as 3 duplas alternadas | média |
| **23, 25** | isopropila / radicais na estrutura | ramificações destacadas com a valência livre marcada | média |
| **26** | 3-etil-2,4-dimetilpentano | esqueleto com etila no C3 e metilas em C2/C4 | média |
| **17, 18, 19** | pent-1-eno, hex-3-ino, hexa-1,3-dieno | esqueleto mostrando a posição da insaturação | baixa |
| **11** | ciclopentano | anel de 5 | baixa |

**Comece pelas três de prioridade alta** (testosterona, citral, 2,2,4-trimetilpentano) — são as que
o aluno não consegue visualizar a partir do texto condensado.

Questões que **não** precisam de figura: Q1-Q5, Q9, Q13, Q14, Q16, Q20, Q21, Q22, Q24 (conceituais
ou de fórmula, sem estrutura para desenhar).

### 4.2 Como criar a figura

Escreva o SVG à mão como constante JS, **copiando o padrão do modelo**. Exemplo real do Física:

```js
const SVG_PV_ISOBARICA = `
<div class="figura">
<svg viewBox="0 0 320 220" role="img" aria-label="Diagrama pressao por volume de uma transformacao isobarica, com a area do trabalho destacada">
  <line x1="55" y1="20" x2="55" y2="185" stroke="#9aa1b4" stroke-width="2"/>
  <line x1="55" y1="185" x2="300" y2="185" stroke="#9aa1b4" stroke-width="2"/>
  <text x="38" y="26" fill="#4b5060" font-size="13" font-style="italic">P</text>
  <text x="298" y="205" fill="#4b5060" font-size="13" font-style="italic">V</text>
</svg>
<span class="cap">A pressao fica constante. O trabalho e a <b>area do retangulo</b>.</span>
</div>`;
```

Convenções obrigatórias (mantenha iguais — é o que o CSS espera):

- **Embrulhe** em `<div class="figura"> ... </div>`
- Feche com `<span class="cap">` — a legenda em uma frase, explicando o que olhar
- `viewBox="0 0 320 220"` (ou `340 240` para diagramas maiores)
- Cores: eixos `#9aa1b4`, ligações `#4b5060`, destaque `#4f46e5`, texto `#4b5060` /
  secundário `#6b7280`, área `#c7d2fe` com `opacity="0.55"`
- `role="img"` + `aria-label` descritivo
- **Todos os textos dentro do viewBox** (se `y` passar da altura, some da tela)
- Subscritos de química: use entidades (`C&#8321;&#8329;H&#8322;&#8328;O&#8322;`) ou Unicode

**Nomenclatura das constantes:** `SVG_` + o que ela mostra, em maiúsculas com `_`.
Ex.: `SVG_TESTOSTERONA`, `SVG_CITRAL`, `SVG_TRIMETILPENTANO`, `SVG_RADICAIS_BUTILA`.

### 4.3 Como ligar a figura a uma questão

Na questão, adicione o campo depois do `enunciado`:

```js
{
  tema: "Citral (UFRGS)",
  enunciado: "...",
  figura: SVG_CITRAL,          // <<< esta linha
  estrutura: "CH₃–C(CH₃)=CH–CH₂–CH₂–C(CH₃)=CH–CHO",
  conceito: "...",
  alternativas: [ ... ]
}
```

### 4.4 Infraestrutura que ainda **não existe** no de Química

O de Química não tem o suporte a figuras. Copie estes 4 pedaços do modelo (Física):

**(a) CSS** — dentro do `<style>`, copie o bloco comentado
`/* ---------- figura (diagrama SVG da questao/aula) ---------- */` e o `.figura` inteiro.

**(b) `renderQuestion()`** — insira a linha da figura logo após o enunciado:

```js
      <p class="q">${q.enunciado}</p>
      ${q.figura ? q.figura : ''}
      ${q.estrutura ? `<div class="formula">...` : ''}
```

**(c) `montarQuiz()`** — adicione `figura: q.figura,` no objeto devolvido, junto de
`tema`/`enunciado`/`estrutura`/`conceito`.

> ⚠️ **Este é o bug mais fácil de cometer aqui.** `montarQuiz()` reconstrói a questão campo por
> campo. Se você criar um campo e esquecer de listá-lo ali, ele **some depois do embaralhamento** —
> e a figura só aparece na primeira questão. Já aconteceu com o campo das aulas.

**(d) Constantes** — no topo do `<script>`, antes de `const QUESTIONS`, declare todos os `SVG_*`.

### 4.5 Verificação da tarefa 2

```bash
node verificar.js simulado.html
```

Deve aparecer uma linha `Figuras: N questoes com diagrama`. O validador rejeita figura sem `<svg>`
e figura com URL externa.

No navegador (F12, console):

```js
QUESTIONS.filter(q => q.figura).length            // deve bater com o número que você criou
QUESTIONS.map((q,i) => q.figura ? i+1 : null).filter(Boolean)
```

Depois abra cada questão com figura e confira: o desenho aparece **abaixo do enunciado**, com
legenda, nada fora da moldura.

---

## 5. TAREFA 3 — Botão "Aprender o assunto do zero"

Esta é a parte maior. Copie do modelo (Física), trocando o conteúdo.

### 5.1 O que copiar, e de onde

Do arquivo `simulado-fisica\saida\simulado-com-figuras.html`:

| Bloco | Como localizar | Tamanho |
|---|---|---|
| CSS do botão e do modal | comentários `.lesson-btn{` até `.lesson-foot` | ~75 linhas |
| HTML do modal | `<div class="modal" id="modal">` | 3 linhas |
| Funções JS | comentário `/* --- aula do assunto (modal) --- */` | ~78 linhas |
| Botão no feedback | `const btnAula` dentro de `revelar()` | ~10 linhas |

Cole **exatamente como está** — o CSS e as funções não dependem do assunto.
Só o objeto `LICOES` é específico de cada matéria.

### 5.2 As aulas: escreva 10 a 12

Estrutura de cada aula (do modelo):

```js
"citral": {
  titulo: "Citral: por que a cadeia é homogênea",
  resumo: "Uma frase que resume o assunto e já entrega o ponto principal.",
  blocos: [
    {t:"h", v:"Título da seção"},
    {t:"p", v:"Parágrafo explicativo. Pode ter <b>negrito</b> e <i>itálico</i>."},
    {t:"formula", v:"CH₃–C(CH₃)=CH–...", leg:"legenda opcional"},
    {t:"figura", v:SVG_CITRAL},                    // reusa a constante da questão
    {t:"destaque", v:"A frase que o aluno tem que levar para a prova."},
    {t:"lista", v:["item 1", "item 2", "item 3"]}
  ],
  erros: [
    "Erro clássico 1 que o aluno comete",
    "Erro clássico 2"
  ]
}
```

Tipos de bloco aceitos: `h`, `p`, `formula` (com `leg` opcional), `figura`, `destaque`, `lista`.
O campo `erros` vira o bloco vermelho **"Onde todo mundo erra"** no fim da aula.

**Sugestão de 12 aulas para este banco:**

1. Postulados de Kekulé e Couper (tetravalência, equivalência)
2. Fim do vitalismo — Wöhler e a ureia
3. Por que o carbono forma tantos compostos
4. Exceções: compostos de carbono que não são orgânicos
5. Classificação do carbono (primário → quaternário)
6. Cadeias: normal × ramificada
7. Cadeias: saturada × insaturada
8. Cadeias: homogênea × heterogênea (a pegadinha do heteroátomo)
9. Cadeias cíclicas e aromáticas
10. Fórmulas moleculares e cálculo de hidrogênios
11. Nomenclatura de hidrocarbonetos (prefixo + infixo + sufixo)
12. Radicais: metil, etil, propil, isopropil, sec-butil, terc-butil

### 5.3 Ligar cada questão à sua aula

Depois de `const LICOES = { ... };`, adicione o mapa (como no modelo):

Use **este mapeamento já pronto** — ele foi montado conferindo as 26 questões na ordem real do
arquivo. Se você criar as aulas com estes mesmos ids, basta colar:

```js
/* ordem conferida: Q1..Q26 do arquivo simulado.html */
const LICAO_POR_QUESTAO = [
  "kekule",            // Q1  postulados de Kekulé e Couper
  "wohler",            // Q2  fim do vitalismo (ureia)
  "excecoes",          // Q3  compostos de carbono inorgânicos (CO2)
  "variedade",         // Q4  tetravalência + cadeias = muitos compostos
  "classificacao-carbono", // Q5  primário/secundário/terciário/quaternário
  "contagem-carbonos", // Q6  2,2,4-trimetilpentano: primários
  "contagem-carbonos", // Q7  2,2,4-trimetilpentano: sec/terc/quat
  "cadeia-ramificada", // Q8  isobutano: ramificada/saturada/homogênea
  "cadeia-insaturada", // Q9  propino: normal/insaturada/homogênea
  "citral",            // Q10 citral: homogênea (O fora da cadeia)
  "cadeia-ciclica",    // Q11 ciclopentano
  "cadeia-aromatica",  // Q12 benzeno
  "cadeia-heterogenea",// Q13 éter vs álcool
  "cadeia-ramificada", // Q14 quando uma cadeia é ramificada
  "testosterona",      // Q15 carbonos terciários na testosterona
  "testosterona",      // Q16 fórmula molecular C19H28O2
  "nomenclatura",      // Q17 pent-1-eno
  "nomenclatura",      // Q18 hex-3-ino
  "nomenclatura",      // Q19 hexa-1,3-dieno
  "formulas-moleculares", // Q20 fórmula do hexa-1,3-dieno
  "formulas-gerais",   // Q21 fórmula geral do alcano
  "radicais",          // Q22 metila
  "radicais",          // Q23 isopropila
  "radicais",          // Q24 terc-butila
  "radicais",          // Q25 radicais na estrutura
  "contagem-carbonos"  // Q26 terciários no 3-etil-2,4-dimetilpentano
];
QUESTIONS.forEach((q, i) => { q.licao = LICAO_POR_QUESTAO[i] || "kekule"; });
```

São **17 ids distintos**. Escreva uma aula para cada um:

`kekule` · `wohler` · `excecoes` · `variedade` · `classificacao-carbono` · `contagem-carbonos` ·
`cadeia-ramificada` · `cadeia-insaturada` · `cadeia-ciclica` · `cadeia-aromatica` ·
`cadeia-heterogenea` · `citral` · `testosterona` · `nomenclatura` · `formulas-moleculares` ·
`formulas-gerais` · `radicais`

**Não invente a ordem de cabeça.** Se você mudar a quantidade ou a ordem das questões, o mapeamento
desalinha e a questão abre a aula errada — o que é pior que não ter botão. Depois de aplicar,
**confira com o teste da seção 6.4**, que roda 20 sorteios e detecta campo perdido.

### 5.4 O botão

Em `revelar()`, logo depois de montar o `fb.innerHTML`, insira (já é o código do modelo):

```js
const lic = LICOES[q.licao];
const btnAula = lic ? `
  <button class="lesson-btn" id="abrirAula" type="button">
    <span class="ico">📘</span>
    <span class="lbl">Aprender o assunto do zero
      <small>${lic.titulo}</small></span>
    <span class="arrow">→</span>
  </button>` : '';

// e dentro do fb.innerHTML, depois do </ul>:
  ${btnAula}

// e o listener:
const abrir = document.getElementById('abrirAula');
if (abrir) abrir.addEventListener('click', () => abrirLicao(q.licao));
```

---

## 6. Verificar tudo antes de publicar

### 6.1 Script

```bash
cd "C:/Users/jcarlos/Documents/simulado-organica"
node verificar.js simulado.html
```

Esperado: `OK: banco de questoes valido. Pode publicar.` com as linhas
`Questoes: 26`, `Aulas: 12`, `Figuras: N`.

### 6.2 No navegador (F12 → Console)

```js
QUESTIONS.length === 26                                          // true
Object.keys(LICOES).length >= 10                                 // true
QUESTIONS.every(q => q.licao && LICOES[q.licao])                 // true  <-- crítico
QUESTIONS.every(q => q.alternativas.filter(a => a.ok).length === 1)   // true
QUESTIONS.every(q => q.alternativas.every(a => a.porque && a.porque.length >= 25))  // true
QUESTIONS.filter(q => q.figura).length                            // o número que você criou
```

### 6.3 Na tela, nesta ordem

1. **Iniciar simulado** → cronômetro corre a partir de 50:00.
2. Questão com figura → desenho aparece **abaixo do enunciado**, legenda visível, nada cortado.
3. Clicar numa alternativa → **não revela nada**, só abre a caixa de confirmação.
4. **Confirmar resposta** → marca verde/vermelho e lista as 5 explicações.
5. **📘 Aprender o assunto do zero** → abre a aula certa (confira o título!).
6. **Esc** → fecha e volta na mesma questão, mesma posição de rolagem.
7. Estreitar a janela para 390 px → sem rolagem horizontal, SVG se ajusta.
8. Recarregar no meio → o painel de registro conta a saída.

### 6.4 Teste do embaralhamento (**o mais importante — já pegou um bug real**)

Rode no console. Ele roda 20 sorteios e confere que toda questão mantém a figura e a aula:

```js
(() => {
  let perdeuFig = 0, perdeuLicao = 0;
  for (let k = 0; k < 20; k++) {
    montarQuiz().forEach((q, i) => {
      if (QUESTIONS[i].figura && !q.figura) perdeuFig++;
      if (QUESTIONS[i].licao  && !q.licao)  perdeuLicao++;
    });
  }
  return { perdeuFig, perdeuLicao, esperado: 0 };
})()
```

**Resultado correto:** `{ perdeuFig: 0, perdeuLicao: 0, esperado: 0 }`

> **Se `perdeuLicao` der 520** (26 questões × 20 sorteios), você esqueceu de incluir
> `licao: q.licao` no objeto devolvido por `montarQuiz()`. Isso foi medido de verdade ao preparar
> este documento: o mapeamento estava perfeito na renderização inicial e **todas** as 520 aulas se
> perdiam depois do primeiro sorteio. O sintoma no aluno é "a primeira questão tem o botão, as
> seguintes não" — porque a questão 1 costuma ser renderizada antes do sorteio.
>
> Depois de adicionar `licao: q.licao` (e `figura: q.figura`), o resultado passa a
> `{ perdeuFig: 0, perdeuLicao: 0 }`.

Confira também que as 26 questões têm aula apontando para um id existente:

```js
QUESTIONS.every(q => q.licao && typeof q.licao === 'string')   // true
[...new Set(QUESTIONS.map(q => q.licao))].length              // 17 (neste banco)
```

---

## 7. Publicar

```bash
cd "C:/Users/jcarlos/Documents/simulado-organica"

# 1. validar
node verificar.js simulado.html

# 2. sincronizar o que o site serve
cp simulado.html index.html

# 3. regenerar o ZIP
rm -f simulado-organica.zip
powershell -NoProfile -Command "Compress-Archive -Path 'index.html','ABRIR-SIMULADO.bat','LEIA-ME.txt' -DestinationPath 'simulado-organica.zip' -Force"

# 4. enviar
git add -A
git -c user.email="simulado@local" -c user.name="Simulado" commit -m "Auditoria, figuras SVG e aulas do assunto"
git push origin main
```

Ou simplesmente:

```bash
bash publicar.sh "Auditoria, figuras SVG e aulas do assunto"
```

### Confirmar que publicou de verdade

Não confie no commit — confira o que o servidor entrega:

```bash
curl -sL "https://maximojota-hue.github.io/simulado-organica/?v=$(date +%s)" > /tmp/site.html
grep -c "const SVG_" /tmp/site.html      # deve ser o número de figuras criadas (antes: 0)
grep -c "const LICOES" /tmp/site.html    # deve ser 1 (antes: 0)
grep -c "ok:true" /tmp/site.html         # deve ser 26
tr -d '\r' < /tmp/site.html | wc -c      # compare com: tr -d '\r' < index.html | wc -c
```

O GitHub Pages leva **~50 segundos** para reconstruir. Se o número ainda for o antigo, aguarde e
repita. Se persistir por mais de 3 minutos, veja `gh api repos/maximojota-hue/simulado-organica/pages/builds/latest`.

⚠️ Compare os tamanhos **depois** de `tr -d '\r'` — o CRLF do Windows muda o valor em alguns KB e
não significa conteúdo diferente.

---

## 8. Relatório final (obrigatório)

Ao terminar, informe exatamente:

```
AUDITORIA
- Questões com gabarito corrigido: [números, ou "nenhuma"]
- Questões com redação ajustada: [números]
- Alternativas reescritas: [números + letra]

FIGURAS
- Constantes SVG criadas: [nomes]
- Questões que receberam figura: [números]
- Aulas que receberam figura: [ids]

AULAS
- Aulas escritas: [quantidade + ids]
- Mapeamento questão → aula: [confirmar alinhamento]

TESTES
- verificar.js: OK / falhas
- 20 sorteios sem perda de campo: OK / falhas
- Mobile 390px: OK / problema
- Publicado e confirmado no ar: sim / não
```

---

## 9. Se der errado

```bash
git status --short && git diff --stat    # ver o que mudou
git log --oneline -5                     # histórico
git revert --no-edit HEAD && git push origin main   # desfazer publicação
```

O commit `6eaf63d` é a versão atual em produção (26 questões, sem aulas nem figuras).
Serve de ponto de retorno.

---

## 10. Resumo executável

```bash
cd "C:/Users/jcarlos/Documents/simulado-organica"

# 1. auditar o banco
node verificar.js simulado.html

# 2. (editar simulado.html: figuras SVG + LICOES + botão)

# 3. validar de novo
node verificar.js simulado.html

# 4. testar no navegador (console + tela, seção 6)

# 5. publicar
bash publicar.sh "Auditoria, figuras SVG e aulas do assunto"

# 6. confirmar
curl -sL "https://maximojota-hue.github.io/simulado-organica/?v=$(date +%s)" | grep -c "const LICOES"
# tem de retornar 1
```
