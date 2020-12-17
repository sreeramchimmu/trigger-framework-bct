public class IncentiveEarningsTotalController {
     @AuraEnabled
    public static List<Incentive_Earnings__c> getIncentiveEarningsTotal(Id oppId){
        system.debug('oppIdTotal-->'+oppId);
        double totalInc=0;
        double ConvertedInc=0;
        List<Incentive_Earnings__c> incList = new List<Incentive_Earnings__c>();
        List<Incentive_Earnings__c> incEarngs = new List<Incentive_Earnings__c>([SELECT Act_Fct_Revenue_amount__c,Id,Is_CFI__c,PreSales_Incentives__c,Revenue_Date__c,SE_Incentives__c,SM_Incentives__c,Total_Incentives__c,CurrencyIsoCode FROM Incentive_Earnings__c WHERE Opportunity_Id__c =:oppId]);
        system.debug('incEarngs-->'+incEarngs.size());
        if(incEarngs.size()>0){
            for(Incentive_Earnings__c inc : incEarngs){
                totalInc += inc.SE_Incentives__c;
            }
            //system.debug('incList-->'+incList);
            if(incEarngs[0].CurrencyIsoCode!='USD'){
                ConvertedInc = currencyConvertionToUSD(incEarngs[0].CurrencyIsoCode,totalInc);
            }
            //incMap.put('IsCFI',incEarngs[0].Is_CFI__c);
            //incMap.put('CurrencyIsoCode',incEarngs[0].CurrencyIsoCode);
            //incMap.put('Incentive',String.valueOf(totalInc));
            //incMap.put('ConvertedInc',String.valueOf(ConvertedInc));
            system.debug('IsCFI-->'+incEarngs[0].Is_CFI__c);
            system.debug('CurrencyIsoCode-->'+incEarngs[0].CurrencyIsoCode);
            system.debug('Incentive-->'+totalInc);
            system.debug('ConvertedInc-->'+ConvertedInc);
            Incentive_Earnings__c c = new Incentive_Earnings__c();
            c.Is_CFI__c=incEarngs[0].Is_CFI__c;
            c.SE_Incentives__c=totalInc;
            c.convertedToUSD__c=ConvertedInc;
            c.CurrencyIsoCode=incEarngs[0].CurrencyIsoCode;
            incList.add(c);
        }
        return incList;
    }
    
    //currency conversion method from other currency to USD
    public static decimal currencyConvertionToUSD(String homeCurrencyCode,Decimal currencyValue){
        List<CurrencyType> currencyList = [SELECT Id, IsoCode, ConversionRate FROM CurrencyType];
        Map<String,Decimal> IsoCode_cRate = new Map<String,Decimal>();
        for(CurrencyType ct: currencyList){
            IsoCode_cRate.put(ct.IsoCode,ct.ConversionRate);
        }
        return (currencyValue/IsoCode_cRate.get(homeCurrencyCode));
    }

}