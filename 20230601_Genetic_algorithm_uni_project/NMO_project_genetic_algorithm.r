library(ggplot2)

# Dystans między dwoma miastami
f_dystans = function(m1, m2) {
  
  rad = pi/180
  lat1 = as.numeric(m1[1] * rad)
  lat2 =  as.numeric(m2[1] * rad)
  lon1 =  as.numeric(m1[2] * rad)
  lon2 =  as.numeric(m2[2] * rad)
  dlon =  as.numeric(lon2 - lon1)
  dlat =  as.numeric(lat2 - lat1)
  a = sin(dlat/2)^2 + cos(lat1) * cos(lat2) * sin(dlon/2)^2
  a= as.numeric(a)
  
  c = as.numeric(2 * atan2(sqrt(a), sqrt(1-a)))
  R = 6371 # Promień Ziemii [km]
  dystans = R * c
  return(dystans) }

# Całkotwita odległość
f_calkowity_dystans = function(droga, miasta) {
  calkowity_dystans = 0
  for (i in 1:(length(droga) - 1)) {
    m1 = miasta[droga[i], ]
    m2 = miasta[droga[i + 1], ]
    dystans = f_dystans(m1, m2)
    calkowity_dystans = calkowity_dystans + dystans
  }
  return(calkowity_dystans)
}

# Początkowa populacja
f_populacja_poczatkowa = function(n_drogi, n_miasta) {
  populacja = list()
  for (i in 1:n_drogi) {
    populacja[[i]] = sample(n_miasta)
  }
  return(populacja)
}

# Mating
f_wybierz_rodzicow = function(populacja, n_rodzice) {
  rodzice = sample(populacja, n_rodzice, replace = FALSE)
  return(rodzice)
}

# Crossover
crossover = function(rodzice, n_dzieci) {
  n_rodzice = length(rodzice)
  n_miasta = length(rodzice[[1]])
  dzieci = vector("list", length = n_dzieci)
  
  for (i in 1:n_dzieci) {
    rodzic1 = rodzice[[i %% n_rodzice + 1]]
    rodzic2 = rodzice[[(i + 1) %% n_rodzice + 1]]
    
    # Random crossover point
    crossover_point = sample(2:(n_miasta - 1), 1)
    
    # Materiał genetyczny od rodzica nr 1
    dzieci[[i]] = rodzic1[1:crossover_point]
    
    # ateriał genetyczny od rodzica nr 2
    missing_genes = rodzic2[!(rodzic2 %in% dzieci[[i]])]
    dzieci[[i]] = c(dzieci[[i]], missing_genes)
  }
  
  return(dzieci)
}

# Mutacja na offspringach
f_mutacja = function(dzieci, r_mutacja) {
  n_dzieci = length(dzieci)
  n_miasta = length(dzieci[[1]])
  
  for (i in 1:n_dzieci) {
    if (runif(1) < r_mutacja) {
      # Pozycja mutowania (2)
      poz_mutacji = sample(n_miasta, 2)
      
      # Wykonanie mutacji
      temp = dzieci[[i]][poz_mutacji[1]]
      dzieci[[i]][poz_mutacji[1]] = dzieci[[i]][poz_mutacji[2]]
      dzieci[[i]][poz_mutacji[2]] = temp
    }
  }
  
  return(dzieci)
}

# Nowa populacja
f_nowa_populacja = function(rodzice, dzieci) {
  nowa_populacja = c(rodzice, dzieci)
  return(nowa_populacja)
}

# Selekcja
elitism_selection = function(populacja, n_drogi) {
  calkowite_dystanse = sapply(populacja, f_calkowity_dystans, miasta = miasta)
  populacja_posortowana = populacja[order(calkowite_dystanse)]
  nowa_populacja = populacja_posortowana[1:n_drogi]
  return(nowa_populacja)
}

### Algorytm genetyczny
f_algorytm_genetyczny = function(miasta, n_populacji, n_generacji, n_rodzice, n_dzieci, r_mutacja) {
  n_miasta = nrow(miasta)
  n_drogi = n_populacji
  
  # Inicjalizacja dla populacji
  populacja = f_populacja_poczatkowa(n_drogi, n_miasta)
  
  # Tworzenie df
  wyniki = vector("numeric", length = n_generacji)
  
  # Main loop algorytmu genetycznego
  for (Generacja in 1:n_generacji) {
    calkowite_dystanse = sapply(populacja, f_calkowity_dystans, miasta = miasta)
    wyniki[Generacja] = min(calkowite_dystanse)
    rodzice = f_wybierz_rodzicow(populacja, n_rodzice)
    
    # Generowanie dzieci z crossover
    dzieci = crossover(rodzice, n_dzieci)
    
    # Mutacja dzieci
    dzieci = f_mutacja(dzieci, r_mutacja)
    
    populacja = f_nowa_populacja(rodzice, dzieci)
    
    # Selekcja
    populacja = elitism_selection(populacja, n_drogi)
  }
  
  # Get city names
  city_names <- filtered_data$city_ascii
  
  # Get the index of the best route
  best_route_index <- which.min(calkowite_dystanse)
  
  # Get the best route
  best_route <- populacja[[best_route_index]]
  
  # Print city names in the best route
  print(city_names[best_route])
  
  return(wyniki)
}



#### WCZYTYWANIE DANYCH

# Lista kolumn do importu z pliku csv - jest ok
selected_columns <- c("city_ascii", "lat", "lng")

# Wybór miast do analizy - im mniej tym dużo mniej czasu potrzeba na wykonanie algorytmu
filter_values <- c("Warsaw"
                   , "Krakow"
                   , "Lodz"
                   , "Wroclaw"
                   , "Poznan"
                   , "Gdansk"
                   , "Szczecin"
                   , "Bydgoszcz"
                   , "Lublin"
                   , "Bialystok"
                   )

# Wczytanie csv jako df
data <- read.csv("cities_poland.csv", header = TRUE, stringsAsFactors = FALSE)[selected_columns]

# Filter na dane - wybiera miasta do algorytmu na podstawie listy miast powyżej
filtered_data <- data[data$city_ascii %in% filter_values, ]

# Dla pewnosci braku errorow w obliczeniach zmiana typu danych na numeryczne
latitude = as.numeric(filtered_data$lat)
longitude = as.numeric(filtered_data$lng)

# DF z dostosowanym typem danych
miasta = data.frame(Latitude = latitude, Longitude = longitude)



#### PARAMETRY ALOGRYTMU GENETYCZNEGO ###
n_populacji = 100
n_generacji = 50
n_rodzice = 70
n_dzieci = 50
r_mutacja = 0.05 # większe prawdopodobieństwo mutacji
#pstwo mutacji

# Wykonaj algorytm 
wyniki = f_algorytm_genetyczny(miasta, n_populacji, n_generacji, n_rodzice, n_dzieci, r_mutacja)

# Wykres wyniku algorytmu
ggplot(data.frame(Generacja = 1:n_generacji, DystansCalkowity = wyniki), aes(x = Generacja, y = DystansCalkowity)) +
  geom_line() +
  labs(x = "Generacja", y = "Dystans Calkowity")

