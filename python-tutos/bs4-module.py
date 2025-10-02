import requests
from bs4 import BeautifulSoup


# Get from url
url = "https://www.gov.uk/search/news-and-communications"
page = requests.get(url)
print(page.content) # Voir le code html source


# Load from file
with open("index.html", "r") as file:
    soup = BeautifulSoup(file.read(), 'html.parser') # parse


# Récupération du titre de la page HTML:
soup.title
# ==> <title>Exercice extraction HTML</title> (un élément HTML)

# Récupération de la chaîne de caractères du titre HTML
soup.title.string
# ==> "Exercice extraction HTML"

# Extraction du texte de la balise h1
h1_text = soup.find("h1").string

# Trouver tous les éléments avec la balise <h2>
soup.find_all('h2')
# ==> renvoie une liste d'éléments HTML

# Trouver le premier élément avec l’id `titre`
soup.find(id="titre")
# ==> <h1 id="titre">Bienvenue sur notre site web</h1>

# Trouver tous les éléments <li>:
soup.find_all("li")

# Trouver tous les éléments <li> avec la classe "product" en utilisant un sélecteur CSS:
soup.select("li.product")
# ==> renvoie une liste d'éléments HTML

# Extraction des noms et des prix des produits dans la liste
all_products = dict()
for product in soup.find_all("li"):
    name = product.find("h2").string
    price_str = product.find("p", class_="price").string
    price_list = price_str.split(" ") # On sépare la chaine avec " " en liste de mots
    all_products[name] = {"prix": price_list[1]} # On récupère le prix (= deuxième mot)
    description = product.find_all("p")[-1].string  # La description est le dernier élément de la liste des paragraphes
    all_products[name]["description"] = description