public function main (string... args) {
    worker w1 {
        string data1 = "string";
        string data2 = "string";
        (data1, data2) -> w2;
        (data1, data2) = <- w2;
        secureFunction(data1, data2);
    }
    worker w2 {
        string data3 = "string";
        string data4 = "string";
        var val = <- w1;
        secureFunction(data3, data4);
        (data3, data4) -> w1;
    }
}
function secureFunction (@untainted string secureIn, string insecureIn) {

}
