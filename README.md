# 🍽️ Nação Nutrida

[![Flutter](https://img.shields.io/badge/Flutter-3.32.8-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.5.0-0175C2?logo=dart)](https://dart.dev)
[![Node.js](https://img.shields.io/badge/Node.js-18+-339933?logo=node.js)](https://nodejs.org)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![CI/CD](https://github.com/Fredericobarbosa/nacao_nutrida_flutter/actions/workflows/ci.yml/badge.svg)](https://github.com/Fredericobarbosa/nacao_nutrida_flutter/actions)

> **Plataforma digital para doação de alimentos com sistema avançado de Analytics e Testes A/B**

Uma aplicação Flutter Web que conecta doadores de alimentos com campanhas sociais, incluindo sistema completo de análise de métricas de uso em tempo real e backend Node.js.

## ⚡ Quick Start

```bash
# 1. Clone o repositório
git clone https://github.com/Fredericobarbosa/nacao_nutrida_flutter.git
cd nacao_nutrida_flutter

# 2. Configure o backend
cd lib/server
cp .env.example .env
# Edite .env com suas credenciais
npm install
npm run dev

# 3. Em outro terminal, configure o frontend
cd ../..
flutter pub get
flutter run -d chrome
```

## 📋 Índice

- [Sobre o Projeto](#-sobre-o-projeto)
- [Funcionalidades](#-funcionalidades)
- [Sistema de Analytics](#-sistema-de-analytics)
- [Tecnologias](#-tecnologias)
- [Instalação](#-instalação)
- [Uso](#-uso)
- [Pipeline CI/CD](#-pipeline-cicd)
- [Contribuição](#-contribuição)
- [Demonstração](#-demonstração)

## 🎯 Sobre o Projeto

O **Nação Nutrida** é uma plataforma web desenvolvida para facilitar doações de alimentos, conectando pessoas que desejam doar com organizações que precisam de ajuda. O projeto inclui um sistema completo de **Testes A/B** e **Analytics** para análise de comportamento dos usuários.

### Problema Resolvido
- **Dificuldade** para encontrar campanhas de doação
- **Falta de transparência** no processo de arrecadação  
- **Ausência de métricas** sobre uso da plataforma
- **Processo manual** e desorganizado de doações

### Solução Oferecida
✅ **Interface intuitiva** para descobrir campanhas  
✅ **Processo de doação** simplificado e transparente  
✅ **Analytics avançado** com 4 tipos de métricas principais  
✅ **Dashboard em tempo real** para análise de uso  
✅ **Sistema de persistência** de dados local  

## 🚀 Funcionalidades

### 👥 Para Usuários Doadores
- **Descoberta de Campanhas** - Lista interativa com informações detalhadas
- **Visualização de Progresso** - Acompanhamento das metas em tempo real  
- **Processo de Doação** - Interface simples para seleção de alimentos
- **Histórico Transparente** - Visualização das contribuições realizadas

### 🏢 Para Organizações
- **Cadastro de Campanhas** - Criação com metas específicas
- **Gestão de Estoque** - Controle de tipos e quantidades de alimentos
- **Monitoramento** - Acompanhamento de doações recebidas
- **Relatórios** - Análise de performance das campanhas

### 📊 Sistema de Analytics (Diferencial)
- **Coleta Automática** - Métricas coletadas sem interferir na UX
- **Dashboard Visual** - Interface para análise dos dados
- **Persistência Local** - Dados mantidos entre sessões
- **API Ready** - Preparado para integração com backend

## 📊 Sistema de Analytics

Implementação completa de **Testes A/B** conforme requisitos acadêmicos:

### 1️⃣ Páginas Mais Acessadas
```dart
// Tracking automático de page views
AnalyticsService().trackPageView('Página Inicial');
```
- Registro de todas as visitas às páginas
- Ranking de popularidade
- Análise de fluxo de navegação

### 2️⃣ Tempo de Renderização  
```dart
// Medição precisa de performance
AnalyticsService().trackPageLoadTime('Login', loadTimeMs);
```
- Tempo de carregamento em millisegundos
- Identificação de gargalos de performance
- Detecção automática de páginas lentas (>1000ms)

### 3️⃣ Botões Mais Clicados
```dart
// Tracking de interações do usuário
AnalyticsService().trackButtonClick('Login', 'Header');
```
- Análise de popularidade de funcionalidades
- Contexto detalhado de cada interação
- Otimização de UX baseada em dados reais

### 4️⃣ Páginas Pesadas
```dart
// Detecção automática de problemas de performance
AnalyticsService().trackHeavyPageMetrics('Dashboard', 
  loadTimeMs: 1200, 
  heavyOperations: ['Data loading', 'Chart rendering']
);
```
- Identificação de páginas com performance ruim
- Análise de operações custosas
- Sugestões automáticas de otimização

## 🛠️ Tecnologias

### Frontend
- **[Flutter 3.32.8](https://flutter.dev)** - Framework principal
- **[Dart](https://dart.dev)** - Linguagem de programação
- **[Material Design 3](https://m3.material.io)** - Sistema de design

### Estado e Dados  
- **[Provider 6.1.5](https://pub.dev/packages/provider)** - Gerenciamento de estado
- **[SharedPreferences 2.3.2](https://pub.dev/packages/shared_preferences)** - Persistência local
- **[HTTP 1.1.0](https://pub.dev/packages/http)** - Cliente HTTP para APIs

### Ferramentas de Desenvolvimento
- **[GitHub Actions](https://github.com/features/actions)** - Pipeline CI/CD
- **[Flutter Analyze](https://docs.flutter.dev/testing/debugging)** - Análise estática
- **[GitHub Pages](https://pages.github.com)** - Hospedagem automática

## 📱 Instalação

### Pré-requisitos
```bash
# Flutter SDK (versão 3.32.8 ou superior)
flutter --version

# Dart (normalmente incluído com Flutter)
dart --version

# Node.js e npm (para o servidor backend)
node --version
npm --version

# Git para clonagem do repositório  
git --version
```

### Passo a Passo

#### 1. Clone o repositório
```bash
git clone https://github.com/Fredericobarbosa/nacao_nutrida_flutter.git
cd nacao_nutrida_flutter
```

#### 2. Configure o Frontend (Flutter)
```bash
# Instale as dependências
flutter pub get

# Verifique se tudo está configurado corretamente
flutter doctor
```

#### 3. Configure o Backend (Node.js/Express)

**3.1 - Configure variáveis de ambiente**
```bash
# Entre na pasta do servidor
cd lib/server

# Copie o arquivo de exemplo
cp .env.example .env

# Abra o arquivo .env e preencha as variáveis:
# DATABASE_URL=sua_url_do_banco_de_dados
# JWT_SECRET=sua_chave_secreta_jwt
# JWT_EXPIRES_IN=1d
```

**3.2 - Instale dependências do servidor**
```bash
# Instale as dependências npm
npm install

# Opcional: Configure o Prisma (se usando banco de dados)
npx prisma migrate dev
```

**3.3 - Inicie o servidor**
```bash
# Desenvolver com hot reload (recomendado)
npm run dev

# Ou em produção
npm run build
npm start
```

O servidor estará rodando em `http://localhost:3000`

#### 4. Volte para a raiz do projeto e execute a app
```bash
cd ../../

# Para dispositivo conectado
flutter run
```

#### 5. Build para produção
```bash
# Web
flutter build web

# Android
flutter build apk

# Backend
cd lib/server && npm run build
```

## 💻 Uso

### Desenvolvimento Local

#### Frontend (Flutter)
```bash
# Executar em modo debug
flutter run -d chrome --debug

# Executar testes
flutter test

# Análise de código
flutter analyze

# Verificar dispositivos disponíveis
flutter devices
```

#### Backend (Node.js/Express)
```bash
# Entrar na pasta do servidor
cd lib/server

# Instalar dependências (se não fez ainda)
npm install

# Executar em produção
npm start

# Verificar logs
npm run dev  # Mostra logs no console

# Executar migrations do banco de dados
npx prisma migrate dev
npx prisma studio  # Interface gráfica do banco
```

### Arquitetura da Aplicação

**Frontend → Backend:**
1. Flutter realiza requisições HTTP para `http://localhost:3000`
2. Backend processa as requisições e acessa o banco de dados
3. Resposta é retornada em JSON para o frontend
4. Analytics são coletados localmente no frontend

**Configuração de API:**
Arquivo: `lib/config/api.dart`
```dart
class ApiConfig {
  static const String baseUrl = 'http://localhost:3000/api';
}
```

### Variáveis de Ambiente Necessárias

Arquivo: `lib/server/.env`
```bash
# Banco de dados (PostgreSQL/MySQL/SQLite)
DATABASE_URL="postgresql://usuario:senha@localhost:5432/nacao_nutrida"

# JWT para autenticação
JWT_SECRET="sua_chave_secreta_muito_segura_aqui"
JWT_EXPIRES_IN="1d"

# Opcional: Porta do servidor
PORT=3000
```

### Acessar Analytics
1. **Execute a aplicação** em modo web
2. **Navegue pelas páginas** para gerar métricas
3. **Clique no botão azul flutuante** na página inicial  
4. **Visualize as métricas** coletadas em tempo real

### Testar Persistência
1. **Use a aplicação** por alguns minutos
2. **Feche completamente** o navegador
3. **Reabra a aplicação** 
4. **Verifique** que os dados permanecem no dashboard

## 🔄 Pipeline CI/CD

O projeto inclui pipeline completo automatizado:

### Workflow GitHub Actions
```yml
# Executa em: Push para main, Pull Requests
Jobs:
  - 🧪 Análise de código (flutter analyze)
  - 🧪 Testes unitários (flutter test)  
  - 🏗️ Build para web (flutter build web)
  - 🚀 Deploy automático (GitHub Pages)
```

### Monitoramento
- **Status badges** no README
- **Logs detalhados** de cada execução
- **Deploy automático** em caso de sucesso
- **Rollback** em caso de falha

### Acessar Pipeline
1. Vá para **GitHub Actions** tab
2. Veja **histórico de execuções**
3. **Logs detalhados** de cada step
4. **Status** de build e deploy

## 🎯 Demonstração

### Demo Online
🌐 **[Acesse a aplicação](https://fredericobarbosa.github.io/nacao_nutrida_flutter/)**

### Funcionalidades para Testar
- ✅ **Navegação** entre páginas (gera page views)
- ✅ **Cliques** em botões (registra interações)
- ✅ **Dashboard Analytics** (botão azul flutuante)
- ✅ **Processo de doação** completo
- ✅ **Persistência** de dados entre sessões

### Métricas Esperadas
Após usar por alguns minutos, você verá:
- **Páginas mais visitadas** com contadores
- **Tempos de renderização** em millisegundos
- **Botões populares** com ranking de cliques  
- **Alertas** para páginas com performance ruim

## 🤝 Contribuição

### Como Contribuir
1. **Fork** do projeto
2. **Crie uma branch** (`git checkout -b feature/nova-funcionalidade`)
3. **Commit** suas mudanças (`git commit -m 'Adiciona nova funcionalidade'`)
4. **Push** para branch (`git push origin feature/nova-funcionalidade`)
5. **Abra um Pull Request**

### Padrões de Código
- Siga as **convenções Dart/Flutter**
- Use **flutter analyze** antes de commits
- Escreva **testes** para novas funcionalidades
- **Documente** mudanças no README

## 📁 Estrutura do Projeto

```
lib/
├── main.dart                 # Entrada da aplicação
├── models/                   # Modelos de dados
│   ├── auth_manager.dart     # Autenticação
│   ├── campaign.dart         # Campanha
│   └── user.dart             # Usuário
├── screens/                  # Telas da aplicação
│   ├── pagina_inicial.dart   # Página inicial
│   ├── descobrir.dart        # Lista campanhas
│   ├── login.dart            # Autenticação
│   ├── detalhes_campanha.dart # Detalhes
│   ├── doar_alimentos.dart   # Doação
│   └── analytics_dashboard.dart # Analytics
├── components/               # Componentes reutilizáveis
│   ├── header.dart           # Cabeçalho
│   ├── footer.dart           # Rodapé  
│   └── left_sidebar.dart     # Menu lateral
└── services/                 # Serviços
    └── analytics_service.dart # Sistema analytics
```

## 📊 Analytics em Números

### Métricas Coletadas Automaticamente:
- **Page Views** - Todas as visualizações de página
- **Load Times** - Performance em millisegundos  
- **Button Clicks** - Interações do usuário
- **Heavy Pages** - Páginas com problemas de performance
- **User Sessions** - Sessões individuais de uso
- **Navigation Paths** - Fluxos de navegação

### Dashboard Inclui:
- 📊 **Gráficos visuais** de todas as métricas
- 🔄 **Atualização** em tempo real  
- 💾 **Persistência** entre sessões
- 🧹 **Limpeza** de dados opcional
- 📤 **Simulação** de envio para API

## 🏆 Diferenciais do Projeto

### Técnicos
✅ **Architecture** - Clean architecture com separação de responsabilidades  
✅ **State Management** - Provider pattern implementado corretamente  
✅ **Analytics Custom** - Sistema próprio, não biblioteca terceirizada  
✅ **Persistence** - Dados mantidos localmente sem backend  
✅ **CI/CD** - Pipeline profissional automatizado  

### Funcionais  
✅ **Real Problem** - Soluciona problema social real  
✅ **Complete UX** - Fluxo completo de usuário implementado  
✅ **Data Driven** - Decisões baseadas em métricas reais  
✅ **Production Ready** - Hospedado e funcional online  
✅ **Scalable** - Preparado para crescimento e backend real  

## 📄 Licença

Este projeto está sob licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

**Desenvolvido por:** 

Frederico Barbosa

Jorge Santos 

Yago Mouro

---

⭐ **Se este projeto foi útil, considere dar uma estrela no repositório!**
