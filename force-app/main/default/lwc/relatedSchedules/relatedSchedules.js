import { LightningElement, api, wire } from 'lwc';
import getSchedules from '@salesforce/apex/RelatedSchedulesByIdController.getSchedules';

const columns = [
    { label: 'Name', fieldName: 'Name', type: 'text' },
    { label: 'Number', fieldName: 'Name__c', type: 'text' },
    { label: 'Time to next stop', fieldName: 'Time_To_Next_Stop__c', type: 'integer' }
];

export default class RelatedSchedules extends LightningElement {
    @api recordId;

    @wire(getSchedules, {stopId: '$recordId'})
    schedules;

    columns = columns;
}