# Projet Prolog – IA stratégique en jeu concurrentiel

Ce dépôt regroupe le travail réalisé dans le cadre d’un **projet Prolog**, où l’objectif est de développer une **intelligence artificielle** capable de jouer à un jeu défini dans le fichier [`consigneProjet.pdf`](./consigneProjet.pdf). L’IA est ensuite confrontée à celles d’autres étudiants dans un tournoi.

🎯 Ce projet est en lien direct avec la **thématique de mon stage** sur l’IA et les comportements stratégiques en économie. J’ai donc choisi de **combiner les deux approches** – théorique et appliquée – dans ce dépôt.

## 📂 Contenu du dépôt

- `Algorithme_explication/` : explication détaillée du fonctionnement de l’IA développée (logique, stratégie, inspiration théorique).
- `Projet_khawa_khawa/` : implémentation complète de l’agent en Prolog, prêt à être utilisé dans les tests et le tournoi.
- `convergence_des_strategies_dans_un_jeu/` : étude théorique sur la convergence du comportement stratégique dans des jeux où les agents cherchent à maximiser leur gain. La question centrale est :
  
  > * Dans un jeu ou les agents cherchent  a maximiser leur gain, vers quel équilibre stratégique leur comportement converge-t-il ?*

- `consigneProjet.pdf` : énoncé officiel du projet de jeu.

## 🔍 Objectifs du projet

- Développer une IA compétitive en Prolog.
- Étudier la convergence des comportements stratégiques vers un équilibre (ex. : Nash, coopération, domination).
- Mettre en parallèle les résultats expérimentaux du projet avec les recherches menées dans le cadre du stage sur l’intelligence artificielle économique.

### 💡 Remarque importante

> **Side note** : dans la **version 2** du jeu, bien que les gains soient cumulés et visibles, essayer d’en tirer un avantage direct peut rendre l’IA **prévisible** et donc **pénalisée** car les autres pourront en prendre profit.  
> Ainsi, la solution optimale dans la version 2 **sera proche de celle de la version 1**, car résoudre efficacement la version 1 permet d’éviter d’être exploité.  
> La principale différence entre les deux versions sera alors une **explosion des scores numériques**, **mais pas un changement dans le classement ou les comportements stratégiques**.

