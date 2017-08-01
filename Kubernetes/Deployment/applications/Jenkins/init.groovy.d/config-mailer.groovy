import jenkins.model.*
def instance = Jenkins.getInstance()
def desc = instance.getDescriptor("hudson.tasks.Mailer")
desc.setReplyToAddress("jennings.liu@sap.com")
desc.setSmtpHost("mailsin.sap.corp")
desc.setDefaultSuffix("@sap.com")
desc.setUseSsl(false)
desc.setSmtpPort("25")
desc.setCharset("UTF-8")
desc.save()