# Como atualizar o simulado

Este arquivo explica a **qualquer** pessoa ou IA como alterar e republicar o simulado.

## Arquivos

| Arquivo | O que e |
|---|---|
| `simulado.html` | **A fonte.** Todo o conteudo (questoes, aulas) esta aqui. E o unico que voce precisa editar. |
| `index.html` | Copia de `simulado.html` que o GitHub Pages serve. **Nao edite** — gerado pelo script. |
| `verificar.js` | Valida o banco de questoes. |
| `publicar.sh` | Valida, sincroniza, gera o ZIP, envia e espera o Pages. |
| `LEIA-ME.txt`, `ABRIR-SIMULADO.bat` | Instrucoes e atalho para quem baixa o ZIP. |

## Regra de ouro

**Edite SOMENTE `simulado.html`.** Nunca mexa em `index.html` — ele e sobrescrito
a cada publicacao. Editar os dois separadamente e a causa numero 1 de o site
mostrar uma versao diferente da que voce acha que publicou.

## Onde esta o conteudo

Dentro de `simulado.html`, no `<script>`, existem dois blocos:

```js
const QUESTIONS = [ ... ];   // o banco de questoes
const LICOES = { ... };      // as aulas (so nos simulados que tem esse recurso)
```

### Formato de cada questao

```js
{
  tema: "Rendimento",
  enunciado: "Pergunta aqui?",
  estrutura: "W = P · dV",          // opcional: aparece num bloco monoespaçado
  conceito: "A regra geral que resolve a questao, em 1 ou 2 frases.",
  licao: "rendimento",              // opcional: id da aula em LICOES
  alternativas: [
    {t: "Texto da alternativa.", ok: true,  porque: "Por que esta certa (min. 25 caracteres)."},
    {t: "Outra alternativa.",    ok: false, porque: "Qual o erro conceitual dela."},
    // ... 5 alternativas, exatamente 1 com ok: true
  ]
}
```

Regras que o validador cobra:

1. Exatamente **1** alternativa com `ok: true` por questao.
2. **Toda** alternativa precisa de `porque` com pelo menos 25 caracteres —
   inclusive a correta. "Esta errada" nao ensina nada.
3. `tema` e `conceito` obrigatorios.
4. Se a questao tem `licao`, esse id precisa existir em `LICOES`.
5. Nao repetir enunciado.

## Passo a passo para atualizar

```bash
cd <pasta do simulado>

# 1. edite o simulado.html (questoes, textos, aulas)

# 2. valide antes de publicar
node verificar.js simulado.html

# 3. publique (valida de novo, sincroniza, faz commit, envia, espera o Pages)
bash publicar.sh "Descreva aqui o que mudou"
```

O script imprime o link no final. Se o site ainda mostrar a versao antiga,
aguarde 1 minuto e recarregue com **Ctrl+Shift+R**.

## Cuidados

- **Embaralhamento:** as corretas podem estar todas na letra "a" no arquivo.
  Nao e problema: o codigo sorteia a posicao a cada tentativa. Mas **nao remova**
  a funcao `montarQuiz()` nem a chamada dela.
- **Campo novo em uma questao:** se voce criar um campo novo e ele sumir na tela,
  veja `montarQuiz()` — ela reconstroi o objeto questao campo por campo, e o que
  nao estiver listado la se perde.
- **Duas pastas, dois repos:** Quimica e Fisica sao projetos separados.
  Nao copie o `simulado.html` de um para o outro (foi o que corrompeu a Quimica
  uma vez). Se precisar reaproveitar, copie so o motor (CSS + script) e
  substitua o array `QUESTIONS`.
- **Nao use Internet Explorer** para abrir: a tela fica em branco.

## Para conferir se publicou de verdade

```bash
curl -sL https://<usuario>.github.io/<repo>/ | grep -o '<title>[^<]*</title>'
```

Se o titulo bater com o que voce editou, esta no ar.
