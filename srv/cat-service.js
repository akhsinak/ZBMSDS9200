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

    this.before('CREATE', 'Emails', async (req) => {
      const { Emails } = cds.entities('EmailService')
      const { address } = req.data
      const userId = req.user && req.user.id

      console.log(userId);
      
      const MAX_EMAILS = 10
      if (userId) {
        console.log("inside userid");
        const count = await SELECT.one`count(*)`.from(Emails).where({ createdBy: userId })
        console.log("count:", count);
        if (count && count['count'] >= MAX_EMAILS) {
          return req.reject(403, `You have reached the maximum limit of ${MAX_EMAILS} emails.`)
        }
      } else {
        // In local dev without auth, count all records as fallback
        const count = await SELECT.one`count(*)`.from(Emails)
        console.log("count:", count);
        if (count && count['count'] >= MAX_EMAILS) {
          return req.reject(403, `You have reached the maximum limit of ${MAX_EMAILS} emails.`)
        }
      }
      
      if (address) {
        const existing = await SELECT.one.from(Emails).where({ address: address })
        if (existing) {
          return req.reject(409, `Email address "${address}" already exists.`)
        }
      }
    })

    this.before('UPDATE', 'Emails', async (req) => {
      const { Emails } = cds.entities('EmailService')
      const { address, ID } = req.data
      
      if (address) {
        const existing = await SELECT.one.from(Emails).where({ address: address })
        if (existing && existing.ID !== ID) {
          return req.reject(409, `Email address "${address}" already exists.`)
        }
      }
    })

    return super.init()
  }
}
