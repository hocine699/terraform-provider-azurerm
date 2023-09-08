## Example: Basic Linux Virtual Machine

This example provisions a basic Linux Virtual Machine using your SSH key for authentication.

Note: this assumes you have a Public SSH Key available at `~/.ssh/id_rsa.pub`

Pour pouvoir utiliser clé SSH, il faut absolument la générer au format .PEM sinon, elle ne fonctionnera pas sur Powershell ou mobaxterm. Voila la commande : "ssh-keygen -t rsa -b 2048 -m PEM -f my_key.pem"
une fois la clé générée, renseigner le chemin dans le fichier main.tf
