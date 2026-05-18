```bash

npm install @sap/cds@latest @sap/xssec@latest @sap/hana-client@latest
npm install --save-dev @sap/hdi-deploy@latest


FOR LOCAL MODE WITH HANA CLOUD ---

****Creating HDI container service:****
cf create-service hana hdi-shared zbmsds9200-hdi

****Creating service key:****
cf create-service-key zbmsds9200-hdi zbmsds9200-hdi-key

****Getting service key:****
cf service-key zbmsds9200-hdi zbmsds9200-hdi-key

****deploying the schema to hana****
npx cds deploy --to hana

****deploying the schema to sqlite****
npx cds deploy --to sqlite:db.sqlite

FOR DEPLOYING TO CLOUD FOUNDRY ----
**build and deploy app**
mbt build
cf deploy mta_archives/zbmsds9200_1.0.0.mtar
```

### Adding emails app to build work zone

[SAPUI5 - App registration on Workzone on BTP](https://www.youtube.com/watch?v=q5Ya_v8LkEI)
