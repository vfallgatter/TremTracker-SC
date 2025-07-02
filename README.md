# Trem Tracker

Projeto acadêmico para simular o rastreamento em tempo real de um trem entre cidades usando backend em Ruby on Rails e frontend em Flutter com Google Maps.

---

## Sobre

Este projeto simula o movimento de um trem em uma linha com várias estações, atualizando a posição a cada 10 segundos. O backend calcula a posição com base na velocidade do trem e nas coordenadas das estações, enquanto o frontend exibe a posição do trem em um mapa interativo.

---

## Tecnologias

- **Backend:** Ruby on Rails  
- **Frontend:** Flutter (Google Maps + Provider)  
- **Comunicação:** API REST JSON  
- **Cache:** Rails cache para persistência de estado entre requisições  

---

## Estrutura do Projeto

- `trem_api/` - backend Rails responsável pela lógica do movimento do trem e API REST.  
- `trem_tracker/` - frontend Flutter que consome a API e exibe o mapa com o trem em movimento.

---

## Como rodar o projeto

### Backend (Rails)

1. Instale Ruby e Rails  
2. Navegue até `trem_api`  
3. Instale as dependências:  
   ```bash
   bundle install

4. Rode o servidor:  
   ```bash
   rails s

5. A API estará disponível em:  
   ```bash
    http://localhost:3000/posicao


### Frontend (Flutter)
1. Instale Flutter SDK

2. Navegue até trem_tracker

3. Rode o app:

   ```bash
    flutter pub get
    flutter run

4. O app irá buscar a posição do trem na API a cada 10 segundos e atualizar o mapa.

### Funcionamento
- O backend mantém o cálculo da posição do trem utilizando a fórmula de Haversine para distância entre coordenadas GPS.

- O trem percorre uma lista de coordenadas que representam a linha férrea, atualizando a posição conforme a velocidade e o tempo decorrido.

- O frontend usa um Timer.periodic para consultar o backend a cada 10 segundos e atualizar o marcador no mapa.

- A posição é exibida com informações de status, próximo ponto e progresso da viagem.

### Ajustes e melhorias futuras
- Expandir a lista de coordenadas para representar com mais fidelidade o trajeto real do trem.

- Implementar autenticação e controle para múltiplos trens.

- Criar histórico e visualização de trajetos anteriores.

- Melhorar UI/UX no app Flutter.

### Contato
- [LinkedIn](https://www.linkedin.com/in/vitorfallgatter/)
- Email: vitorhugofallgatter@gmail.com
- Instagram : _fallgatter

### Licença

Este projeto é para fins acadêmicos e está aberto para contribuições.

