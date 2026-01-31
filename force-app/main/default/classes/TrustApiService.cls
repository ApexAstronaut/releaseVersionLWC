public with sharing class TrustApiService {

    public class SystemInfoWrapper {
        @AuraEnabled public String instanceName;
        @AuraEnabled public String releaseVersion;
        @AuraEnabled public String status;
        @AuraEnabled public String statusColor;
        @AuraEnabled public String maintenanceWindow;
    }

    @AuraEnabled(cacheable=true)
    public static SystemInfoWrapper getSystemInfo() {
        SystemInfoWrapper info = new SystemInfoWrapper();
        
        try {
            // 1. Get Instance Name dynamically
            Organization org = [SELECT InstanceName, IsSandbox FROM Organization LIMIT 1];
            info.instanceName = org.InstanceName;

            // --- TROUBLESHOOTING STEP ---
            // If you are still getting 404, UNCOMMENT the line below and put your actual instance (e.g. 'USA1052' or 'CAN98')
            // info.instanceName = 'CAN98'; 
            
            // 2. Call Salesforce Trust API
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            String endpoint = 'https://api.status.salesforce.com/v1/instances/' + info.instanceName + '/status';
            request.setHeader('Content-Type', 'application/json');
            request.setEndpoint(endpoint);
            request.setMethod('GET');
            
            // Debug the exact URL we are hitting
            System.debug('Trust API Request URL: ' + endpoint);
            
            HttpResponse response = http.send(request);
            
            if (response.getStatusCode() == 200) {
                Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                
                // Release Version Logic
                String versionFromApi = (String) results.get('releaseVersion');
                if (String.isNotBlank(versionFromApi)) {
                    info.releaseVersion = versionFromApi;
                } else {
                    info.releaseVersion = 'Hyperforce: Version Classified 🕵️';
                }

                // Maintenance Window Logic
                if (results.containsKey('maintenanceWindow') && results.get('maintenanceWindow') != null) {
                    info.maintenanceWindow = (String) results.get('maintenanceWindow');
                } else {
                    info.maintenanceWindow = 'No Window Listed';
                }

                // Status Logic
                if (results.containsKey('status')) {
                     String statusEnum = (String) results.get('status');
                     if (statusEnum == 'OK') {
                        info.status = 'Active';
                        info.statusColor = 'slds-text-color_success';
                     } else {
                        info.status = statusEnum;
                        info.statusColor = 'slds-text-color_error';
                     }
                } else {
                    info.status = 'Active'; 
                    info.statusColor = 'slds-text-color_success';
                }

            } else {
                // 404 Handling
                info.releaseVersion = 'Instance Not Found';
                info.status = 'Error: ' + response.getStatusCode();
                info.statusColor = 'slds-text-color_error';
                info.maintenanceWindow = 'Unavailable';
                
                System.debug('API Error Body: ' + response.getBody());
            }
            
        } catch (Exception e) {
            info.releaseVersion = 'Script Error';
            info.status = 'Failed';
            info.statusColor = 'slds-text-color_error';
            info.maintenanceWindow = 'Check Logs';
            System.debug('Exception: ' + e.getMessage());
        }
        
        return info;
    }
}