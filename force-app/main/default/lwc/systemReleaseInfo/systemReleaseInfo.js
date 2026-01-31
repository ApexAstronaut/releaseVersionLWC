import { LightningElement, wire } from 'lwc';
import getSystemInfo from '@salesforce/apex/TrustApiService.getSystemInfo';

export default class SystemReleaseInfo extends LightningElement {
    @wire(getSystemInfo)
    systemInfo;
}