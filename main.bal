type Bbox record {
    string southLat;
    string northLat;
    string westLon;
    string eastLon;
};

type Units record {
    string date;
    string temperature;
    string rain_sum;
    string windspeed;
    string sunrise;
    string sunset;
};

type WeatherItem record {
    string date;
    string temperature;
    string windspeed;
    string sunrise;
    string sunset;
};

type Output record {
    string latitude;
    string longitude;
    string timezone;
    string[] boundingbox;
    string display_name;
    WeatherItem[] weather;
};

type ReadingsItem record {
    string date;
    decimal temperature;
    decimal rain_sum;
    decimal windspeed;
    string sunrise;
    string sunset;
};

type Weather record {
    Units units;
    ReadingsItem[] readings;
};

type Address record {
    string state_district;
    string state;
    string country;
    string country_code;
};

type Location record {
    string lat;
    string lon;
    int place_id;
    Bbox bbox;
    string timezone_abbreviation;
    string 'type;
    Address address;
};

const BASE_TEMPURATURE = 33.0;

function transform(Location location, Weather weather) returns Output => let var isTemperatureInCelcius = weather.units.temperature == "°C", var isWindspeedInKMPH = weather.units.windspeed == "km/h" in {
        latitude: location.lat,
        longitude: location.lon,
        timezone: location.timezone_abbreviation,
        boundingbox: [
            location.bbox.southLat,
            location.bbox.northLat,
            location.bbox.westLon,
            location.bbox.eastLon
        ],
        display_name: location.address.state_district + ", " + location.address.state + ", " + location.address.country,
        weather: from var readingsItem in weather.readings
            where <float>readingsItem.temperature >= BASE_TEMPURATURE
            let var tmp = readingsItem.temperature
            let var windSpeed = readingsItem.windspeed
            select {
                date: readingsItem.date,
                temperature: isTemperatureInCelcius ? convertCelsiusToFahrenheit(tmp).toString() + "°F" : tmp.toString() + "°C",
                windspeed: isWindspeedInKMPH ? convertKMPHToMPH(windSpeed).toString() + " mph" : windSpeed.toString() + " km/h",
                sunrise: readingsItem.sunrise,
                sunset: readingsItem.sunset
            }
    };

function convertCelsiusToFahrenheit(decimal celsius) returns decimal => (celsius * 9 / 5) + 32;

function convertKMPHToMPH(decimal kmph) returns decimal => kmph * 0.621371;
