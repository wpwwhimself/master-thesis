# Całość
- [ ] tytuł
- [ ] synopsis
- [ ] bibliografia
## Wstęp
### cel i znaczenie pracy
- [x] rys historyczny
- [x] wydarzenia będące tłem badania
- [x] podsumowanie
- [ ] zacytować jakieś badania powiązujące te cosie z ekonomią
### modele rynków finansowych
- [ ] rynek finansowy
    - [x] definicja rynku finansowego
    - [ ] definicja instrumentów finansowych
        - [ ] co to są akcje
        - [ ] co to są indeksy giełdowe
    - [ ] opis tego, co się dzieje na rynku finansowym
    - [ ] podział rynku?
- [ ] modelowanie rynków finansowych
    - [ ] co to jest dopasowanie
    - [ ] opisanie błądzenia losowego
    - [ ] metoda najmniejszych kwadratów
    - [ ] istotność parametrów
    - [ ] kryteria informacyjne
    - [ ] ustandaryzowanie pogrubień i pochyleń
    - [ ] testy statystyczne
        - [ ] ==wszystko, czego używam w pracy, muszę rozpisać wzorem?==
### przegląd literatury
- [ ] znaleźć literaturę
    - [ ] ==ile pozycji w literaturze?
    - [ ] ==czy linki do artykułów są w porządku?
- [ ] kilka słów o pozycjach
- [ ] ==czy tę sekcję będę mógł zastąpić opisem modeli użytych, czy to wyżej?==
### pakiety
- [ ] ==czy wszystkie pakiety opisywać?
- [x] rugarch
- [x] msgarch
## Metodologia badawcza
### wybór danych
- [x] opisanie, co wybrałem
### analiza danych
- [x] przedstawienie szeregów
- [x] statystyki opisowe
- [x] testy normalności
### wybór odpowiedniego modelu
- [ ] ==czy praca ma być podsumowaniem badań czy ilustrować ich przebieg?==
#### dopasowanie modelu średniej warunkowej
- [x] pierwsze korelogramy
- [x] dopasowanie różnych arma
- [x] porównanie kryteriów
- [x] wybór modeli
#### markov
- [x] testy ARCH
- [x] dopasowanie różnych GARCH
- [x] porównanie kryteriów
- [x] wybór modeli
- [x] ==jak to jest z tą wymagalnością parametrów?==
- [x] wykresy reżimów
- [x] showcase parametrów modeli
#### garchx
- [x] wymyślić jakie szeregi externali wykorzystać
- [x] dopasowanie GARCH
- [x] porównanie kryteriów
- [x] wybór modeli
- [x] showcase parametrów modeli
### predykcje
- [ ] ==horyzont predykcji==
- [x] wykonać predykcje
- [ ] przeliczyć na wartości akcji/indeksu ==czy ma to sens?==
## Analiza wyników
### ocena jakości predykcji
- [ ] porównanie prognoz z faktycznymi wartościami indeksu
### analiza wpływu na notowania
- [ ] dogłębne spojrzenie na te momenty zwiększonej wahliwości
- [ ] jakie straty na rynku w tym czasie się stały
### porównanie z innymi modelami
- [ ] zastanowić się nad sensem tego rozdziału
- [ ] z jakimi innymi modelami?
## Wnioski
### podsumowanie wyników analizy
- [ ] streszczenie tego wszystkiego, co się wydarzyło do tej pory
### ograniczenia i usprawnienia
- [ ] analiza horyzontu czasowego
- [ ] analiza zakresu wybieranych modeli
- [ ] analiza wyboru danych
- [ ] wybór regresorów w GARCHX
### po co to
- [ ] ogólnie po co prognozować
- [ ] do czego można to wykorzystać
- [ ] na co trzeba uważać
- [ ] morał