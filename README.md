# Pokédex App 🐾

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat&logo=dart&logoColor=white)
![License](https://img.shields.io/badge/License-Free-blue)

Um aplicativo móvel desenvolvido em **Flutter** que consome a **PokéAPI** para exibir uma lista completa de pokémons, com imagens, nomes e número da Pokédex. Possui sistema de busca em tempo real, paginação otimizada e layout responsivo.

---

## Tecnologias Utilizadas

- [Flutter](https://flutter.dev/) (Dart)
- [PokéAPI](https://pokeapi.co/)
- [http](https://pub.dev/packages/http) – requisições HTTP
- [cached_network_image](https://pub.dev/packages/cached_network_image) – cache de imagens
- IDE recomendada: Android Studio ou VS Code

---

## Funcionalidades

- **Lista completa de Pokémons**
  - Nome (primeira letra maiúscula)
  - Número da Pokédex
  - Imagem oficial maior (150x150)
- **Busca em tempo real**
  - Filtra qualquer pokémon, mesmo que não tenha sido carregado
  - Feedback quando nenhum resultado é encontrado
- **Paginação eficiente**
  - Carrega grandes quantidades de pokémons sem travar o app
- **Layout responsivo**
  - Adaptável a diferentes tamanhos de tela
- **Design moderno**
  - Cartões com imagens grandes e cores atraentes
- **Tela de detalhes**
  - Habilidades, tipos, stats e animação com Hero

## Estrutura do Projeto

lib/
├─ main.dart # Arquivo principal
├─ models/
│ └─ pokemon.dart # Modelo de Pokémon
├─ services/
│ └─ poke_api_service.dart # Serviço de API
├─ screens/
│ ├─ home_screen.dart # Tela principal com lista e busca
│ └─ pokemon_detail_screen.dart # Tela de detalhes do Pokémon
└─ widgets/
└─ pokemon_tile.dart # Card de Pokémon com imagem maior

yaml
Copiar código

---

## Instalação e execução

1. **Clone o repositório**

```bash
git clone https://github.com/seu-usuario/pokedex_app.git
cd pokedex_app
Instale as dependências

bash
Copiar código
flutter pub get
Rode o app em um emulador ou dispositivo físico

bash
Copiar código
flutter run
Certifique-se de que o modo desenvolvedor está habilitado e que o dispositivo/emulador está conectado.

Dependências principais
http: ^0.13.6

cached_network_image: ^3.3.1

flutter_lints: ^5.0.0

cupertino_icons: ^1.0.8

Melhorias Futuras
Sistema de favoritos para salvar pokémons preferidos

Dark Mode

Tela de evoluções do Pokémon

Animações adicionais na tela de detalhes

Filtragem avançada por tipos e habilidades

Autor
Cassiano
