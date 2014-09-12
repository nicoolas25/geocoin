# Geocoin

Cette application permet de visualiser les résultats d'une recherche leboncoin sur une carte.

## Utilisation

L'idéal est de l'exécuter en local car la version hébergée sur Heroku ne sera pas forcément à jour.

    $ git clone git@github.com:nicoolas25/geocoin.git
    $ cd geocoin
    $ bundle install
    $ bundle exec rackup -p 4567
    $ x-www-browser http://127.0.0.1:4567/

Dans la page affichée, vous devrez entrer un clé d'API (voir ci-dessous), l'URL de votre
[recherche leboncoin][exemple], le nombre de page à rechercher et l'endroit ou la carte devra
être centrée.

## Clé d'API

Je ne livre bien entendu pas ma clé d'API. Pour obtenir une clé de ce type il suffit
de se rendre sur la [console développeur][console] de Google puis de :

* créer un projet,
* ajouter _Google Maps Geolocation API_ et _Google Maps JavaScript API v3_ aux APIs accessibles et
* de récupérer la clé d'accès à l'API depuis le menu latéral _Credentials_.

[console]: https://code.google.coom/apis/console
[exemple]: http://www.leboncoin.fr/annonces/offres/ile_de_france/occasions/?f=a&th=1&q=poney
