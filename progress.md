# Całość
- [x] tytuł
- [x] synopsis i keywords
- [x] bibliografia
- [x] wypełnić do 60 stron
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
- [x] arma a stopy procentowe (zacytować)
- [x] arch a długości opóźnień dla danych finansowych
- [x] przykład, czemu spadki są bardziej nagłaśniane niż wzrosty
- [x] wypisać błędy dopasowania
- [x] kryteria informacyjne
- [x] preferencje stosowania kryteriów informacyjnych
- [x] ustandaryzowanie pogrubień i pochyleń
- [x] testy statystyczne
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
- [x] coś o oxmetrics
- [x] coś o tsm
- [x] coś o pythonie
- [x] coś o julii
## Metodologia badawcza
### wybór danych
- [x] opisanie, co wybrałem
- [x] czemu akurat te, a nie inne spółki? dopasowanie modelu markowa nie wypaliło
- [x] wig20 vs "nie wszyscy należą do wig20"
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
- [ ] interpretacja modeli - różnice między reżimami
#### garchx
- [x] wymyślić jakie szeregi externali wykorzystać
- [x] dopasowanie GARCH
- [x] porównanie kryteriów
- [x] wybór modeli
- [x] showcase parametrów modeli
- [x] czy miałoby sens wziąć zmienność WIG20 (garch np.) i wrzucić to jako zmienną objaśniającą? *tak się robi*
- [x] pokombinować z innymi zmiennymi objaśniającymi (WIG20)
- [ ] GARCHX - WIG, S&P, Nasdaq, DAX, kursy walut jako X
- [ ] interpretacja wyników
### predykcje
- [x] horyzont predykcji *7 dni jest w porządku*
- [x] wykonać predykcje
- [x] porównanie prognoz z faktycznymi wartościami indeksu -- *nie prognozuję wartości*
- [x] błędy prognoz (RMSE, MAPE?)
- [x] wnioski
## Analiza wyników
### analiza wpływu na notowania
- [x] dogłębne spojrzenie na te momenty zwiększonej wahliwości
- [x] jakie straty na rynku w tym czasie się stały
- [x] jeszcze jedna strona
### podsumowanie wyników analizy
- [x] streszczenie tego wszystkiego, co się wydarzyło do tej pory
- [x] uzupełnić o prognozy
### ograniczenia i usprawnienia
- [x] analiza horyzontu czasowego
- [x] analiza zakresu wybieranych modeli
- [x] analiza wyboru danych
- [x] wybór regresorów w GARCHX
### po co to
- [x] ogólnie po co prognozować
- [x] do czego można to wykorzystać -- więcej
- [x] na co trzeba uważać -- więcej
- [x] morał
- [x] jeszcze półtorej strony
- [x] zmienić tytuł
