# 🔄 CI/CD Pipeline - Nação Nutrida

Este projeto utiliza GitHub Actions para automação de CI/CD com builds, testes e deploy automáticos.

## 🚀 Pipelines Configurados

### 1. **CI/CD Principal** (`ci-cd.yml`)
**Triggers:** Push para `main`/`develop`, Pull Requests para `main`

**Jobs:**
- ✅ **Test**: Executa testes, análise e formatação
- 🌐 **Build Web**: Gera build para web
- 📱 **Build Android**: Gera APK para Android  
- 🚢 **Deploy Web**: Deploy automático no GitHub Pages (apenas main)

### 2. **Release** (`release.yml`)
**Triggers:** Push de tags `v*.*.*` (ex: `v1.0.0`)

**Jobs:**
- 📦 Cria release automático no GitHub
- 📱 Anexa APK e App Bundle
- 🌐 Deploy da versão web

### 3. **Code Quality** (`code-quality.yml`)
**Triggers:** Push para `main`/`develop`, Pull Requests

**Jobs:**
- 📊 Análise de qualidade de código
- 🔍 Verificação de formatação
- 🛡️ Auditoria de segurança
- 📈 Relatório de cobertura de testes

## 🛠️ Como Usar

### Deploy Automático (Web)
1. Faça push para a branch `main`
2. O pipeline automatically fará deploy em: `https://fredericobarbosa.github.io/nacao_nutrida_flutter/`

### Criar Release
1. Crie uma tag de versão:
```bash
git tag v1.0.0
git push origin v1.0.0
```
2. O pipeline criará automaticamente:
   - Release no GitHub
   - APK para download
   - App Bundle para Play Store

### Verificar Builds
- Acesse a aba **Actions** no GitHub
- Veja o status de todos os pipelines
- Downloads de artifacts disponíveis

## 📋 Pré-requisitos

### Para GitHub Pages (Deploy Web)
1. Vá em Settings > Pages
2. Selecione Source: "GitHub Actions"
3. O deploy será automático após o primeiro push

### Para Releases
- Certifique-se de que as tags seguem o padrão `v*.*.*`
- Example: `v1.0.0`, `v1.2.3`, `v2.0.0-beta`

## 🔧 Customizações

### Alterar versão do Flutter
Edite nos arquivos `.yml`:
```yaml
flutter-version: '3.32.8'  # Altere para sua versão
```

### Adicionar novos ambientes
Crie novos jobs nos pipelines para:
- iOS builds (requer macOS runner)
- Windows builds
- Testes de integração
- Deploy para Firebase Hosting

### Configurar secrets
Para funcionalidades avançadas, adicione em Settings > Secrets:
- `FIREBASE_TOKEN` (para Firebase deploy)
- `PLAY_STORE_KEY` (para deploy automático na Play Store)
- `APP_STORE_CONNECT_KEY` (para App Store)

## 🏆 Status dos Pipelines

[![CI/CD Pipeline](https://github.com/Fredericobarbosa/nacao_nutrida_flutter/actions/workflows/ci-cd.yml/badge.svg)](https://github.com/Fredericobarbosa/nacao_nutrida_flutter/actions/workflows/ci-cd.yml)

[![Code Quality](https://github.com/Fredericobarbosa/nacao_nutrida_flutter/actions/workflows/code-quality.yml/badge.svg)](https://github.com/Fredericobarbosa/nacao_nutrida_flutter/actions/workflows/code-quality.yml)

## 📚 Links Úteis

- [GitHub Actions para Flutter](https://docs.github.com/en/actions)
- [Flutter CI/CD Best Practices](https://docs.flutter.dev/deployment/cd)
- [GitHub Pages Setup](https://pages.github.com/)