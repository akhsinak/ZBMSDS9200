const cds = require('@sap/cds')

module.exports = class EmailService extends cds.ApplicationService {
  init() {
    this.on('READ', 'Emails', async (req, next) => {
      const userId = req.user && req.user.id
      if (userId && req.query && req.query.SELECT) {
        req.query.where({ createdBy: userId })
      }
      return next()
    })

    return super.init()
  }
}
