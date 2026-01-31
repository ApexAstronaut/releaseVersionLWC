@IsTest
private class TrustApiServiceTest {

    // 1. MOCK: Direct Success (Standard Path)
    private class TrustApiDirectMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            
            // Return valid object immediately
            res.setBody('{' +
                '"key": "USA1052", ' +
                '"releaseVersion": "Winter \'26 Patch 14.18", ' +
                '"status": "OK", ' +
                '"maintenanceWindow": "Sundays 12:00 AM"' +
            '}');
            res.setStatusCode(200);
            return res;
        }
    }

    // 2. MOCK: Fallback Logic (404 -> Search Success)
    private class TrustApiFallbackMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');

            // Logic: If looking up directly, fail. If searching, succeed.
            if (req.getEndpoint().contains('?q=')) {
                // SEARCH returns a LIST of results (Array), not a single object
                res.setBody('[' +
                    '{' +
                        '"key": "CAN98", ' +
                        '"releaseVersion": "", ' + // Empty version to test Witty Message
                        '"status": "OK", ' +
                        '"maintenanceWindow": "Saturdays 10:00 PM"' +
                    '}' +
                ']');
                res.setStatusCode(200);
            } else {
                // Direct lookup returns 404
                res.setStatusCode(404);
            }
            return res;
        }
    }

    // 3. MOCK: Error Path
    private class TrustApiErrorMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(500);
            return res;
        }
    }

    // TEST 1: Happy Path (Direct Match)
    @IsTest
    static void testGetSystemInfoDirect() {
        Test.setMock(HttpCalloutMock.class, new TrustApiDirectMock());

        Test.startTest();
        TrustApiService.SystemInfoWrapper result = TrustApiService.getSystemInfo();
        Test.stopTest();

        System.assertEquals('Winter \'26 Patch 14.18', result.releaseVersion);
        System.assertEquals('Sundays 12:00 AM', result.maintenanceWindow);
        System.assertEquals('Active', result.status);
    }

    // TEST 2: Fallback Path (Direct 404 -> Search found) & Witty Message
    @IsTest
    static void testGetSystemInfoFallback() {
        Test.setMock(HttpCalloutMock.class, new TrustApiFallbackMock());

        Test.startTest();
        TrustApiService.SystemInfoWrapper result = TrustApiService.getSystemInfo();
        Test.stopTest();

        // 1. Verify Fallback worked (we got data)
        System.assertNotEquals('Instance Not Found', result.releaseVersion, 'Should have found instance via search fallback');
        
        // 2. Verify Witty Message Logic (Mock sent empty string for version)
        System.assertEquals('Hyperforce: Version Classified 🕵️', result.releaseVersion);
        
        // 3. Verify Maintenance Window
        System.assertEquals('Saturdays 10:00 PM', result.maintenanceWindow);
    }

    // TEST 3: Hard Error
    @IsTest
    static void testGetSystemInfoError() {
        Test.setMock(HttpCalloutMock.class, new TrustApiErrorMock());

        Test.startTest();
        TrustApiService.SystemInfoWrapper result = TrustApiService.getSystemInfo();
        Test.stopTest();

        System.assert(result.status.startsWith('Failed'), 'Status should indicate failure');
    }
}