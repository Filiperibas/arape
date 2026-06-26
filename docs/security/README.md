# 🔒 Evidências de Segurança da Informação

Esta pasta contém os artefatos da análise de segurança do Arape, em complemento
à seção **Segurança da Informação** do `README.md` principal do repositório.

## Conteúdo

- **`zap-report.html`** — relatório HTML gerado pelo OWASP ZAP 2.17.0 a partir
  da varredura ativa contra `https://arape.vercel.app`.

## Como reproduzir a varredura

1. Instalar o [OWASP ZAP](https://www.zaproxy.org/download/).
2. Abrir o ZAP → **Automated Scan**.
3. URL a atacar: `https://arape.vercel.app`
4. Scan Policy: **Default Policy**
5. Use traditional spider: ✅
6. Use ajax spider: ✅ (`Always` com Firefox)
7. Clicar **Attack** e aguardar (~5–10 min).
8. **Relatório → Generate Report → Traditional HTML** → salvar nesta pasta.

## Validação cruzada

Os findings do ZAP foram complementados com:

- **GitHub Secret Scanning + Push Protection** (ativos no repositório)
- **Dependabot alerts + security updates** (ativos no repositório)
- **`flutter analyze`** rodando a cada build (zero issues)

Ver a seção *Segurança da Informação* do `README.md` principal para a análise
completa, mapeamento do OWASP Top 10 2025 e mitigações aplicadas via
`vercel.json`.
