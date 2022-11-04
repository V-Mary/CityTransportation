public with sharing class WheatherCallout {
    @AuraEnabled
    public  static String makeCallout() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://avenga-school.herokuapp.com/weather');
        req.setMethod('GET');
        req.setHeader('address', 'testAdress');
  
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug(res.getBody());

        return res.getBody();
    }
}
