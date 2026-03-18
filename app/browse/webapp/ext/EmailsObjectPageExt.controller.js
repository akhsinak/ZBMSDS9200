sap.ui.define(["sap/ui/core/mvc/ControllerExtension", "sap/base/Log"], function (ControllerExtension, Log) {
  "use strict";

  return ControllerExtension.extend("localemailapp2.browse.ext.EmailsObjectPageExt", {
    override: {
      editFlow: {
        onAfterSave: function () {
          try {
            var oExtensionAPI = this.base && this.base.getExtensionAPI && this.base.getExtensionAPI();
            if (oExtensionAPI && oExtensionAPI.routing && oExtensionAPI.routing.navigateToRoute) {
              oExtensionAPI.routing.navigateToRoute("EmailsList");
            }
          } catch (e) {
            Log.error("Failed to navigate back to Emails list after save", e);
          }
        }
      }
    }
  });
});
