#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {
  # Your application server logic 
    
  library(magrittr)
  f_model <- system.file("modelo.rds", package = "ancaptcha")
  # MISTERIO
  parm <<- list(
    input_dim = c(32L, 192L), output_vocab_size = 36L, 
    output_ndigits = 6L, path_files = "img/rfb", n_train = 10000L, 
    batch_size = 32L, n_epochs = 15L
  )
  modelo <- torch::torch_load(f_model)$to(device = "cpu")
  
  googleCloudStorageR::gcs_auth(
    # Sys.getenv("JSON_FILE")
    system.file("auth.json", package = "ancaptcha")
  )
  
  output$captcha_img <- shiny::renderPlot({
    shiny::validate(shiny::need(
      input$captcha_file,
      "Por favor suba um Captcha para a plataforma"
    ))
    # browser()
    cap <- captcha::read_captcha(input$captcha_file$datapath) 
    plot(cap)
  })
  
  shiny::observe({
    # browser()
    if (!is.null(input$captcha_file)) {
  
      decrypted <- captcha::decrypt(
        input$captcha_file$datapath,
        modelo
      )
      shiny::updateTextInput(
        session,
        "label",
        value = decrypted
      )
    }
  })
  
  shiny::observeEvent(input$salvar, {
    
    tmp <- tempdir()
    classificado <- captcha::classify(
      input$captcha_file$datapath,
      input$label
    )
    googleCloudStorageR::gcs_upload(
      classificado, "ancaptcha",
      name = basename(classificado)
    )
    shinyalert::shinyalert(
      "Obrigado!",
      text = shiny::tagList(
        "Arquivo submetido com sucesso."
      ),
      type = "success",
      closeOnClickOutside = TRUE,
      closeOnEsc = TRUE,
      showConfirmButton = FALSE,
      html = TRUE,
      size = "m",
      imageWidth = 300
    )
    
  })
  
  
  
}
