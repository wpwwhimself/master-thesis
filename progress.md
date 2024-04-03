# Całość
- [ ] tytuł
- [ ] synopsis i keywords
- [x] bibliografia
## Wstęp
### cel i znaczenie pracy
- [x] rys historyczny
- [x] wydarzenia będące tłem badania
- [x] podsumowanie
- [x] zacytować jakieś badania powiązujące te cosie z ekonomią
### modele rynków finansowych
#### rynek finansowy
- [x] definicja rynku finansowego
- [x] definicja instrumentów finansowych
- [x] co to są akcje
- [x] co to są indeksy giełdowe
- [x] opis tego, co się dzieje na rynku finansowym
- [x] podział rynku?
#### modelowanie rynków finansowych
- [x] co to jest dopasowanie
- [ ] arma a stopy procentowe (zacytować)
- [ ] arch a długości opóźnień dla danych finansowych
- [ ] przykład, czemu spadki są bardziej nagłaśniane niż wzrosty
- [ ] wypisać błędy dopasowania
- [ ] istotność parametrów
- [x] kryteria informacyjne
- [ ] preferencje stosowania testów statystycznych
- [x] ustandaryzowanie pogrubień i pochyleń
- [ ] testy statystyczne
- [x] wszystko, czego używam w pracy, muszę rozpisać wzorem? *najważniejsze*
### przegląd literatury
- [x] ile pozycji w literaturze? -- *tyle ile teraz jest OK*
- [x] czy linki do artykułów są w porządku? *tak, są*
- [x] czy tę sekcję będę mógł zastąpić opisem modeli użytych, czy to wyżej? *tak*
- [x] usunąć tę sekcję
### pakiety
- [x] czy wszystkie pakiety opisywać? -- *najważniejsze*
- [x] rugarch
- [x] msgarch
- [ ] jeszcze 2 strony
## Metodologia badawcza
### wybór danych
- [x] opisanie, co wybrałem
### analiza danych
- [x] przedstawienie szeregów
- [x] statystyki opisowe
- [x] testy normalności
### wybór odpowiedniego modelu
- [x] czy praca ma być podsumowaniem badań czy ilustrować ich przebieg? *preferowalnie podsumowanie, ale ważne decyzje też można opisać*
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
- [x] jak to jest z tą wymagalnością parametrów? *można pominąć*
- [x] wykresy reżimów
- [x] showcase parametrów modeli
#### garchx
- [x] wymyślić jakie szeregi externali wykorzystać
- [x] dopasowanie GARCH
- [x] porównanie kryteriów
- [x] wybór modeli
- [x] showcase parametrów modeli
- [x] czy miałoby sens wziąć zmienność WIG20 (garch np.) i wrzucić to jako zmienną objaśniającą? *tak się robi*
- [ ] pokombinować z innymi zmiennymi objaśniającymi (WIG20)
### predykcje
- [x] horyzont predykcji *7 dni jest w porządku*
- [x] wykonać predykcje
- [x] porównanie prognoz z faktycznymi wartościami indeksu -- *nie prognozuję wartości*
- [ ] błędy prognoz (RMSE, MAPE?)
## Analiza wyników
### analiza wpływu na notowania
- [ ] dogłębne spojrzenie na te momenty zwiększonej wahliwości
- [x] jakie straty na rynku w tym czasie się stały
- [ ] 
### porównanie z innymi modelami
- [ ] zastanowić się nad sensem tego rozdziału
- [ ] modele stochastyczne -- może są jakieś pakiety -- jeśli nie, to wywalić sekcję
## Wnioski
### podsumowanie wyników analizy
- [ ] streszczenie tego wszystkiego, co się wydarzyło do tej pory
- [ ] uzupełnić o prognozy
- [ ] więcej!
### ograniczenia i usprawnienia
- [x] analiza horyzontu czasowego
- [x] analiza zakresu wybieranych modeli
- [ ] analiza wyboru danych
- [x] wybór regresorów w GARCHX
### po co to
- [ ] ogólnie po co prognozować
- [ ] do czego można to wykorzystać -- więcej
- [ ] na co trzeba uważać -- więcej
- [ ] morał