require 'sinatra'
require 'find'
require 'pry'
require 'fileutils'

get "/" do

  file_paths = []
  Find.find('invoices') do |path|
  file_paths.push(path) if File.extname(path) == ".pdf"
  end

  file_paths_to_be_sent = []
  Find.find('invoices_sent') do |path|
  file_paths_to_be_sent.push(path) if File.extname(path) == ".pdf"
  end

  pdfs = []
 
  file_paths.each do |file|

    file_name = file_paths.find {|current_file| current_file == file}
  
      if file_name 
          invoices_to_be_sent = true
        else 
         invoices_to_be_sent = false
      end

      invoices_link = file_name
      invoices_sent = false
      pdfs.push({invoices_link: file_name, invoices_sent: invoices_sent, invoices_to_be_sent: invoices_to_be_sent})
  
  end

  file_paths_to_be_sent.each do |file|

    file_name2 = file_paths_to_be_sent.find {|current_file| current_file == file}
    
    if file_name2 
        invoices_sent = true
      else 
        invoices_sent = false
      end

      invoices_link = file_name2
      invoices_to_be_sent = false
      pdfs.push({invoices_link: file_name2, invoices_sent: invoices_sent, invoices_to_be_sent: invoices_to_be_sent})
  
  end
  erb :invoice, :locals => {:pdfs => pdfs }

end


get "/invoices/:invoice_name" do
  file_name = file_paths.find {|file| file == "invoices/#{params[:invoice_name]}.pdf"}

  if file_name 
    invoices_to_be_sent = true
  else 
    invoices_to_be_sent = false
  end

  file_name2 = file_paths.find {|file| file == "invoices/invoices_sent#{params[:invoice_name]}.pdf"}

  if file_name2 
    invoices_sent = true
  else 
    invoices_sent = false
  end

  invoices_link = file_name

  erb :invoice, :locals => {:invoices_to_be_sent => invoices_to_be_sent, :invoices_sent => invoices_sent, :invoices_link => invoices_link }

end

post "/move" do
  if params[:invoices_to_be_sent] == "true"
  file_name = params[:invoices_link].chars.drop(9).join
  source_path = "./invoices/#{file_name}"
  target_path = "./invoices_sent/#{file_name}"
  File.rename source_path, target_path
  redirect "/"
end

end


