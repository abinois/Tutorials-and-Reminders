import csv

# - - - - - - Read csv file
with open('couleurs_preferees.csv') as f:
    # --- Version list
    reader = csv.reader(f, delimiter=',')       # inclut la 1ère ligne du csv
    for ligne in reader:
        print(ligne)                            # `ligne` est une liste de string
    # --- Version dict
    reader = csv.DictReader(f, delimiter=',')   # exclut la 1ère ligne du csv pour générer les clés du dict
    for ligne in reader:
        print(ligne)                            # `ligne` est un dict dont les clés sont la 1ère ligne du csv


# - - - - - - Write csv file
en_tete = ["titre", "description"]                  # Créer une liste pour les en-têtes
titres, descriptions = [...], [...]                 # Les données à écrires, ici 2 lists de str, une par colonne
with open('data.csv', 'w') as f:                    # Créer un nouveau fichier
    writer = csv.writer(f, delimiter=',')           # Créer un objet writer avec ce fichier
    writer.writerow(en_tete)                        # Écrire la ligne des en-têtes
    for titre, descr in zip(titres, descriptions):  # Parcourir les données
        writer.writerow([titre, descr])             # Écrire une nouvelle ligne avec le titre et la description