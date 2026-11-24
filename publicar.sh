#!/usr/bin/env bash
# Publica (ou atualiza) o simulado no GitHub Pages.
#
#   ./publicar.sh                 -> publica a pasta atual
#   ./publicar.sh "mensagem"      -> publica com mensagem de commit propria
#
# Faz, em ordem: valida o banco de questoes, sincroniza index.html,
# regenera o ZIP, commita, envia e espera o Pages reconstruir.

set -e
cd "$(dirname "$0")"

MSG="${1:-Atualiza o simulado}"

echo ""
echo "==================================================="
echo "  PUBLICANDO O SIMULADO"
echo "==================================================="

# ---- 1) precisa ser repositorio git com remoto ----
if [ ! -d .git ]; then
  echo "  ERRO: esta pasta nao e um repositorio git."
  echo "  Rode uma vez:  git init && git remote add origin <url-do-repo>"
  exit 1
fi
if ! git remote get-url origin >/dev/null 2>&1; then
  echo "  ERRO: nenhum remoto 'origin' configurado."
  exit 1
fi

# ---- 2) o arquivo fonte precisa existir ----
if [ ! -f simulado.html ]; then
  echo "  ERRO: simulado.html nao encontrado nesta pasta."
  exit 1
fi

# ---- 3) validar o banco de questoes ----
echo ""
echo "  [1/6] Validando as questoes..."
if command -v node >/dev/null 2>&1; then
  if ! node verificar.js simulado.html; then
    echo ""
    echo "  PUBLICACAO CANCELADA: corrija os erros acima e rode de novo."
    exit 1
  fi
else
  echo "  (node nao encontrado — pulando a validacao)"
fi

# ---- 4) garantir o que o GitHub Pages serve ----
echo "  [2/6] Sincronizando index.html..."
cp simulado.html index.html
echo "        ok: index.html == simulado.html"

# ---- 5) conferir que nao ha lixo de outro simulado ----
echo "  [3/6] Conferindo o titulo do arquivo..."
TITULO=$(grep -o '<title>[^<]*</title>' simulado.html | head -1 | sed 's/<[^>]*>//g')
echo "        titulo: $TITULO"

# ---- 6) regenerar o ZIP de distribuicao, se existir a pasta de arquivos ----
if [ -f ABRIR-SIMULADO.bat ] && [ -f LEIA-ME.txt ]; then
  echo "  [4/6] Regenerando o ZIP..."
  NOME_ZIP=$(ls *.zip 2>/dev/null | head -1)
  [ -z "$NOME_ZIP" ] && NOME_ZIP="simulado.zip"
  rm -f "$NOME_ZIP"
  if command -v powershell >/dev/null 2>&1 || command -v powershell.exe >/dev/null 2>&1; then
    PWSH=$(command -v powershell || command -v powershell.exe)
    "$PWSH" -NoProfile -Command "
      Compress-Archive -Path 'simulado.html','ABRIR-SIMULADO.bat','LEIA-ME.txt' -DestinationPath '$(pwd -W 2>/dev/null || pwd)/$NOME_ZIP' -Force
    " >/dev/null 2>&1 && echo "        ok: $NOME_ZIP" || echo "        (nao consegui gerar o zip — siga sem ele)"
  else
    echo "        (powershell nao encontrado — siga sem o zip)"
  fi
else
  echo "  [4/6] Sem .bat/LEIA-ME nesta pasta — pulando o ZIP."
fi

# ---- 7) commit e push ----
echo "  [5/6] Enviando para o GitHub..."
git add -A
if git diff --cached --quiet; then
  echo "        nada mudou desde o ultimo envio."
else
  git -c user.email="simulado@local" -c user.name="Simulado" commit -q -m "$MSG"
  echo "        commit: $MSG"
fi
BRANCH=$(git rev-parse --abbrev-ref HEAD)
git push -q origin "$BRANCH"
echo "        enviado para origin/$BRANCH"

# ---- 8) esperar o Pages reconstruir ----
REPO=$(git remote get-url origin | sed -E 's#.*github\.com[:/]([^/]+)/([^/.]+)(\.git)?#\1/\2#')
echo "  [6/6] Aguardando o GitHub Pages reconstruir..."

if command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
  for i in $(seq 1 40); do
    STATUS=$(gh api "repos/$REPO/pages/builds/latest" 2>/dev/null | grep -o '"status":"[a-z]*"' | head -1 | cut -d'"' -f4)
    if [ "$STATUS" = "built" ]; then
      echo "        build concluido."
      break
    fi
    sleep 5
  done
else
  echo "        (gh nao disponivel — o Pages costuma levar ~1 minuto)"
fi

USUARIO=$(echo "$REPO" | cut -d/ -f1 | tr 'A-Z' 'a-z')
NOME=$(echo "$REPO" | cut -d/ -f2)
URL="https://$USUARIO.github.io/$NOME/"

echo ""
echo "==================================================="
echo "  PUBLICADO"
echo "==================================================="
echo "  Link: $URL"
echo ""
echo "  Se o link ainda mostrar a versao antiga, aguarde 1 minuto"
echo "  e recarregue com Ctrl+Shift+R (forca atualizacao)."
echo ""
