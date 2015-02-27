module EncryptHelper
  
  def encrypt(message)
    AES.encrypt(message, ENV['EncryptKey'], {:iv => ENV['EncryptVI']})
  end
  
  def decrypt(message)
    AES.decrypt(message, ENV['EncryptKey'])
  end
  
end
