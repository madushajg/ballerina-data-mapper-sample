import ballerina/test;
import ballerina/io;

@test:Config {
    dataProvider: data
}
function transformTest(string inputFile1, string inputFile2, string expectedFile) returns error? {
    json weatherJson = check io:fileReadJson(inputFile1);
    json locationJson = check io:fileReadJson(inputFile2);
    Weather weather = check weatherJson.cloneWithType();
    Location location = check locationJson.cloneWithType();
    Output transformResult = transform(location, weather);

    json expectedJson = check io:fileReadJson(expectedFile);
    Output expected = check expectedJson.cloneWithType();
    test:assertEquals(transformResult, expected);
}
