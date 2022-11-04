import { LightningElement } from 'lwc';
import makeCallout from '@salesforce/apex/WheatherCallout.makeCallout';

export default class WeatherBusStop extends LightningElement {
    temp;

    handleClick(){
        makeCallout({}).then(resp => {
            this.temp = JSON.parse(resp).temp;
        })
    }
}