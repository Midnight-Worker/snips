## Das wichtigste Git-Modell

```
Arbeitsordner → Staging Area → lokales Repository → GitHub
     git add       git commit          git push
```

- Arbeitsordner: Dateien, die du gerade bearbeitest
- Staging Area: Auswahl für den nächsten Commit
- lokales Repository: deine gespeicherte Historie
- `origin/main`: letzter bekannter Stand auf GitHub

Der wichtigste Diagnosebefehl ist immer:

```
git status
```

## 1. Historie übersichtlich ansehen

```
git log --oneline --graph --decorate --all
```

Kompakter Alias:

```
git config --global alias.tree "log --oneline --graph --decorate --all"
```

Danach:

```
git tree
```

Beispiel:

```
* e42a991 (HEAD -> main) add icons
* ac12fe3 (origin/main) browser-sync
* ce73563 update placeholder
```

`HEAD` zeigt, wo du dich gerade befindest.

## 2. Einen alten Commit ansehen und zurückkehren

Zuerst Commit-ID suchen:

```
git tree
```

Dann den alten Zustand betreten:

```
git switch --detach ce73563
```

Jetzt kannst du Dateien ansehen und testen. Du hast nichts gelöscht.

Zurück zum aktuellen Stand:

```
git switch main
```

Merksatz:

```
git switch --detach COMMIT → Zeitreise
git switch main            → zurück in die Gegenwart
```

## 3. Einzelne Datei aus einem alten Commit holen

Du möchtest nicht komplett zurück, sondern nur eine alte Version von `.vimrc`:

```
git restore --source=ce73563 .vimrc
```

Dann prüfen:

```
git diff
```

Wenn die Version richtig ist:

```
git add .vimrc
git commit -m "restore previous vim configuration"
```

## 4. Nicht gespeicherte Änderungen verwerfen

Eine Datei wurde bearbeitet, aber noch nicht mit `git add` vorgemerkt:

```
git restore datei.txt
```

Alle nicht vorgemerkten Änderungen verwerfen:

```
git restore .
```

Achtung: Diese Änderungen sind anschließend normalerweise weg.

Vorher immer:

```
git diff
git status
```

## 5. Datei wieder aus der Staging Area nehmen

Du hast versehentlich ausgeführt:

```
git add .bashrc
```

Nimm die Datei aus dem nächsten Commit heraus:

```
git restore --staged .bashrc
```

Die Datei und deine Änderungen bleiben erhalten. Nur das `git add` wird rückgängig gemacht.

```
git restore --staged DATEI → aus Staging entfernen
git restore DATEI          → Änderungen verwerfen
```

Dieser Unterschied ist wichtig.

## 6. Letzten Commit korrigieren

Commit-Nachricht ändern:

```
git commit --amend -m "richtige Nachricht"
```

Vergessene Datei ergänzen:

```
git add vergessene-datei.txt
git commit --amend --no-edit
```

Das eignet sich besonders, solange der Commit noch nicht gepusht wurde.

## 7. Einen veröffentlichten Commit rückgängig machen

Wenn der Commit bereits auf GitHub liegt, verwende:

```
git revert COMMIT-ID
```

Beispiel:

```
git revert e42a991
git push
```

`revert` löscht keine Historie. Es erzeugt einen neuen Commit, der die alte Änderung rückgängig macht.

```
A → B → C → Rücknahme von C
```

Das ist für veröffentlichte Commits normalerweise die sicherste Methode.

## 8. Lokale Commits zurücknehmen

Nur wenn noch nicht gepusht wurde.

Commit entfernen, Änderungen aber behalten:

```
git reset --soft HEAD~1
```

Commit und Staging zurücknehmen, Änderungen behalten:

```
git reset HEAD~1
```

Bedeutung von `HEAD~1`:

```
ein Commit vor dem aktuellen Commit
```

Zwei Commits zurück:

```
git reset --soft HEAD~2
```

Diese beiden Varianten behalten deine Dateien. Vermeide vorerst:

```
git reset --hard
```

`--hard` kann ungespeicherte Arbeit löschen.

## 9. Änderungen vorübergehend weglegen

Du arbeitest an etwas, musst aber kurz den Branch wechseln:

```
git stash push -m "angefangene Änderung"
```

Gespeicherte Zwischenstände ansehen:

```
git stash list
```

Änderungen zurückholen:

```
git stash pop
```

Praktisch wie eine Schublade für unfertige Arbeit.

## 10. Branches

Neuen Branch erstellen und betreten:

```
git switch -c neue-idee
```

Branches anzeigen:

```
git branch
```

Zurück:

```
git switch main
```

Änderungen übernehmen:

```
git switch main
git merge neue-idee
```

Branch löschen, wenn alles übernommen wurde:

```
git branch -d neue-idee
```

Branches sind ideal zum Experimentieren:

```
git switch -c test-neues-layout
```

Wenn es funktioniert: mergen. Wenn nicht: Branch löschen.

## 11. Pull-Konflikte und auseinanderlaufende Branches

Für deinen persönlichen Workflow ist Rebase beim Pull sinnvoll:

```
git pull --rebase
```

Standard dauerhaft setzen:

```
git config --global pull.rebase true
```

Bei einem Konflikt:

```
git status
```

Dateien bearbeiten und diese Markierungen entfernen:

```
<<<<<<< HEAD
deine eine Version
=======
die andere Version
>>>>>>> Commit
```

Dann:

```
git add konflikt-datei
git rebase --continue
```

Notausgang:

```
git rebase --abort
```

## 12. Der Lebensretter: `git reflog`

Wenn du glaubst, einen Commit verloren zu haben:

```
git reflog
```

Das zeigt auch frühere Positionen von `HEAD`:

```
11af929 HEAD@{1}: commit: icon
880458b HEAD@{2}: commit: icons
```

Einen vermeintlich verlorenen Stand retten:

```
git switch -c rettung 11af929
```

Solange der Commit noch im Reflog steht, lässt sich erstaunlich viel reparieren.

## Was du wirklich beherrschen solltest

|Situation|Befehl|
|---|---|
|Zustand prüfen|`git status`|
|Änderungen ansehen|`git diff`|
|Historie ansehen|`git tree`|
|Alten Commit besuchen|`git switch --detach ID`|
|Zurück in die Gegenwart|`git switch main`|
|Datei aus Staging entfernen|`git restore --staged DATEI`|
|Dateiänderung verwerfen|`git restore DATEI`|
|letzten Commit korrigieren|`git commit --amend`|
|gepushten Commit zurücknehmen|`git revert ID`|
|lokalen Commit zurücknehmen|`git reset --soft HEAD~1`|
|Arbeit zwischenlagern|`git stash`|
|Experimentierbranch erstellen|`git switch -c NAME`|
|verlorene Commits finden|`git reflog`|

## Deine wichtigste Sicherheitsregel

Bevor du bei einem Problem irgendetwas reparierst:

```
git status
git tree
git diff
```

Und wenn du unsicher bist, erstelle einen Rettungsbranch:

```
git branch rettung-vor-reparatur
```

Das verändert deine Dateien nicht. Es setzt lediglich ein Lesezeichen auf den aktuellen Commit.

Wenn du diese Befehle beherrschst, bist du nicht mehr auf `add`, `commit`, `push` beschränkt – dann kannst du dich in der Git-Historie bewegen, Änderungen sicher zurücknehmen und die meisten Fehler selbst retten.