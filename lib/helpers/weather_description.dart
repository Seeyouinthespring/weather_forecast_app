class WeatherDescription{
  WeatherDescription._();

  static const Map<int, String> WEATHER_MAP = {
    0: 'безоблачно',
    1: 'ясно',
    2: 'переменная облачность',
    3: 'пасмурно',
    45: 'туман',
    48: 'изморозь',
    51: 'морось легкая',
    53: 'морось умеренная',
    55: 'морось плотная',
    56: 'легкая изморось',
    57: 'интенсивная изморось',
    61: 'слабый дождь',
    63: 'умеренный дождь',
    65: 'сильный дождь',
    66: 'умеренный дождь с градом',
    67: 'сильный дождь с градом',
    71: 'слабый снегопад',
    73: 'умеренный снегопад',
    75: 'сильный снегопад',
    77: 'мокрый снег',
    80: 'слабый проливной дождь',
    81: 'умеренный проливной дождь',
    82: 'сильный проливной дождь',
    85: 'слабый снег',
    86: 'сильный снег',
    95: 'гроза',
    96: 'гроза с градом',
    99: 'шторм',
  };

  static String getWindDirection(int d){
    if (d < 24)
      return 'Северный';
    else if (d < 69)
      return 'Северо-восточный';
    else if (d < 114)
      return 'Восточный';
    else if (d < 159)
      return 'Юго-восточный';
    else if (d < 204)
      return 'Южный';
    else if (d < 249)
      return 'Юго-западный';
    else if (d < 294)
      return 'Западный';
    else if (d < 339)
      return 'Северо-западный';
    else return 'Северный';
  }
}
