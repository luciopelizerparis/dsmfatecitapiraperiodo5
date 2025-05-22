import 'package:flutter/material.dart';
//Importando a dependência qr_flutter, definida no
// pubspec.yaml
import 'package:qr_flutter/qr_flutter.dart';

//Classe TelaCardapio herda de StatelessWidget
class TelaCardapio extends StatelessWidget {
  @override
  //Método obrigatório, deve-se fazer a sobrescrita
  // devido a herança aplicada
  Widget build(BuildContext context) {
    // retorna a estrutura da tela 
    return MaterialApp(
      //titulo da tela
      title: 'Cardápio QR',
      // esquema de cores para toda a tela
      theme: ThemeData(primarySwatch: Colors.green),
      // preenchimento da tela será dada pela classe
      // CardapioPage
      home: CardapioPage(),
    );
  }
}

//Classe CardapioPage também herda da classe Stateless
class CardapioPage extends StatelessWidget {
  //cria a lista com conteúdo do tipo (instância) Prato
  final List<Prato> pratos = [
    //Cada instância de Prato tem suas propriedades
    // definidas e é adicionada na lista. Neste ponto
    // o ideal é carregar por uma Query (ResultSet), 
    // direto do BD
    Prato(
      nome: "Lasanha à Bolonhesa",
      imagemUrl: "link img cdn",
      detalhesUrl: "https://fatecitapira.cps.sp.gov.br/",
    ),
    Prato(
      nome: "Sushi Variado",
      imagemUrl: "link img cdn",
      detalhesUrl: "https://fatecitapira.cps.sp.gov.br/",
    ),
    Prato(
      nome: "Pizza Marguerita",
      imagemUrl: "link img cdn",
      detalhesUrl: "https://fatecitapira.cps.sp.gov.br/",
    ),
    Prato(
      nome: "Salada Caesar",
      imagemUrl: "link img cdn",
      detalhesUrl: "https://fatecitapira.cps.sp.gov.br/",
    ),
  ];

  @override
  // Sobrescrita do método build para a classe CardapioPage
  Widget build(BuildContext context) {
    // Retorna a ESTRUTURA Scaffold para preencher o home
    // da MaterialApp da classe TelaCardapio
    return Scaffold(
      // Titulo na barra superior da tela
      appBar: AppBar(title: Text("Cardápio")),
      // O conteúdo principal do Scaffold terá
      // uma lista, que está sendo construida (builder)
      body: ListView.builder(
        // itemCount recebe a quantidade de pratos nas
        // lista
        itemCount: pratos.length,
        // Para a "construção" dos itens, elementos da
        // listView, é utilizado o contexto desta classe
        // e o índice, assim a ListView terá a quantidade
        // de elementos a carregar
        itemBuilder: (context, index) {
          // cada variável prato recebe os dados do
          // prato no índice que está sendo lida a listView
          final prato = pratos[index];
          // retorna um Card, uma área com aparência de cartão
          // para manter os dados com uma boa visualização
          return Card(
            // define todas as margens internas do cartão
            // para 10 pixels
            margin: EdgeInsets.all(10),
            // a propriedade elevation define um relevo, se 
            // aumentar ou diminuir o valor (5) altera o 
            // aspecto visual do card, alterando o "nível"
            // de relevo
            elevation: 5,
            // ListTile mostrará os itens da lista
            child: ListTile(
              // Define as margens internas 
              contentPadding: EdgeInsets.all(15),
              // a propriedade leading irá carregar
              // o link do cdn que tem a imagemURL,
              // com largura (width) de 80, altura
              // (height) de 80 e boxfit.cover irá
              // ajustar a imagem na área definida
              // independente do tamanho original
              // da imagem
              leading: Image.network(prato.imagemUrl, 
                                width: 80, height: 80, 
                                fit: BoxFit.cover),
              // Ainda dentro da lista que está no card
              // define o titulo como o nome do prato,
              // com fonte tamanho 10 e negrito (bold)
              title: Text(prato.nome, 
                            style: TextStyle(
                            fontSize: 18, 
                            fontWeight: FontWeight.bold)
                      ),
              // define o subtitulo da lista que está
              // no card com margem interna, no topo, com 
              // 10 pixels
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 10),
                // Gera o QrCode pela função QrImageView
                child: QrImageView(
                  // a propriedade data mantém todas 
                  // informações embutidas no QRCode,
                  // que serão lida ao scanner, neste caso
                  // apenas irá direcionar para o site da
                  // fatec, que está no atributo detalhesUrl
                  // da instância prato
                  data: prato.detalhesUrl,
                  // Define a versão do qrcode
                  version: QrVersions.auto,
                  // define o tamanho do qrcode
                  size: 80.0,
                ),
              ),
            ),
          );
        },
      ),
    );
  } // Fim do método
} // fim da classe
//Classe Prato para definir os atributos, similar
// ao que implementamos no CustomButton
class Prato {
  // Atributos
  final String nome;
  final String imagemUrl;
  final String detalhesUrl;
  // Definindo os atributos como obrigatórios
  Prato({required this.nome, required this.imagemUrl,
   required this.detalhesUrl});
}
