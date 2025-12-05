# 📱 ReviewStation – App Flutter

Projeto desenvolvido em **Flutter** utilizando o padrão arquitetural **MVVM-C**, focado em criar um aplicativo de catálogo e avaliação de mídias que consome a API **ReviewStation** em toda sua usabilidade, garantindo estrutura, organização e testabilidade.

---

## 🎯 Visão Geral do Projeto

Este é o **aplicativo cliente** do sistema ReviewStation.  
O app consome uma **API RESTful** para gerenciar um catálogo de mídias:

- 🎬 Filmes  
- 📚 Livros  
- 🎮 Jogos  

Os usuários podem:

- Criar avaliações (reviews)  
- Consultar catálogo
- Visualizar notas médias
- Interagir com os itens cadastrados

O projeto prioriza:

- Arquitetura limpa  
- Testabilidade  
- Segurança  
- Manutenção facilitada  

---

## 🏛️ Arquitetura – MVVM-C

O projeto segue **rigorosamente** o padrão **MVVM-C**:

### **MVVM**
Responsável por gerenciar o estado e separar a lógica de apresentação da interface (UI).

### **Coordinator (C)**
Gerencia o fluxo de navegação e mantém Views e ViewModels desacoplados do roteamento.

---

## 📂 Estrutura de Pastas (Camadas)

| Camada | Pasta | Responsabilidade |
|-------|--------|------------------|
| **Domain (Models)** | `resources/models` | DTOs espelhando o schema do MongoDB |
| **Data (Services)** | `resources/services` | Comunicação com a API (HTTP, JWT) + parsing JSON |
| **Flow (Coordinator)** | `resources/shared/coordinator` | Controle de navegação e injeção de dependências |
| **Presentation (Scenes)** | `scenes/` | Telas agrupadas por funcionalidade (login/, home/) |
| **UI / Design System** | `components/` e `resources/shared/styles` | Widgets reutilizáveis, tema, cores, tipografia |

---

## 🔑 Segurança e Autenticação

O cliente usa autenticação **JWT (JSON Web Token)**:

- **Login:** POST `/auth/login`
- **Token Storage:** salvo em `LocalStorageService` usando `shared_preferences`
- **Autorização:** `ApiClient` injeta `Authorization: Bearer <token>` automaticamente  
  → usado em rotas protegidas, como:
  - POST `/reviews`
  - PUT `/users`

---

## 🚀 Como Executar o Projeto

### **1. Pré-requisitos**
- Backend ReviewStation online (Node.js/Render) com **CORS ativado**
- Flutter SDK instalado

### **2. Configurar a URL da API**

Edite o arquivo:

`lib/resources/services/api_client.dart`


E atualize o valor de:

```dart ```
`_baseUrl = 'https://sua-url-da-api';`

### **3. Instalar dependências**
`flutter pub get`

### **4. Executar o app**
`flutter run`

---

### **📋 Fluxos Disponíveis (E2E)**

| Ação                     | Recurso            | Status                             |
| ------------------------ | ------------------ | ---------------------------------- |
| **Login Seguro**         | `POST /auth/login` | Token JWT salvo no dispositivo     |
| **Listagem do Catálogo** | `GET /item`        | Carrega itens e notas na HomeScene |
| **Criar Avaliação**      | `POST /reviews`    | Envia formulário com JWT no header |

---

### **👤 Contato**

### **Desenvolvido por:**
Lvasp16rnd – Lucas
