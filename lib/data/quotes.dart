import 'dart:math';

class QuotesData {
   List<Map<String, dynamic>> _quotes = [ 
      {'quote': 'Your mental health is a priority. Your happiness is essential. Your self-care is a necessity.',
                'author': 'Unknown'},

      {'quote': 'What mental health needs is more sunlight, more candor, and more unashamed conversation.',
                'author': 'Glenn Close'},

      {'quote': 'I am not afraid of storms, for I am learning how to sail my ship.' ,
                'author': 'Louisa May Alcott'},

      {'quote': 'Healing takes time, and asking for help is a courageous step.',
                'author': 'Mariska Hargitay'},

      {'quote': 'Mental illness is nothing to be ashamed of, but stigma and bias shame us all.',
                'author': 'Bill Clinton'},
   ];

   Map<String, dynamic> getRandomQuote() {
      final random = Random();
      return _quotes[random.nextInt(_quotes.length)];
   }
}
