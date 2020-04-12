hc_mapa <- function(tab, tab_geojson) {
  
  texto_tooltip <- paste0(
    '<span style="font-size:12px; font-weight: bold;">{point.munip_nome}</span><br/>',
    'População: <b>{point.populacao} habitantes</b><br/>'
  )
  
  highcharter::highchart(type = "map") %>% 
    highcharter::hc_add_series(
      mapData = tab_geojson,
      states = list(hover = list(color = "#a4edba")),
      joinBy = c("municipio_cod", "munip_cod"),
      data = tab,
      name = "Selecionado",
      borderColor = "#0a0a0a"
    ) %>%
    highcharter::hc_colorAxis(
      tickPixelInterval = 100,
      dataClasses = highcharter::color_classes(
        breaks = c(0, 0, 1, 1),
        colors = c("#f5e9e7", "#f5e9e7", "#005180")
      )
    ) %>%
    highcharter::hc_legend(
      enabled = FALSE
    ) %>%
    highcharter::hc_tooltip(
      pointFormat = texto_tooltip,
      headerFormat = NULL
    ) %>% 
    highcharter::hc_mapNavigation(
      enabled = TRUE,
      enableDoubleClickZoom = TRUE,
      enableMouseWheelZoom = TRUE,
      buttonOptions = list(
        verticalAlign = "bottom"
      )
    ) %>%
    hc_custom_exporting(align = "left")
  
}

hc_custom_exporting <- function(hc, align = "right") {
  highcharter::hc_exporting(
    hc,
    enabled = TRUE,
    buttons = list(
      contextButton = list(
        align = align,
        menuItems = c(
          "printChart",
          "downloadPNG",
          "downloadJPEG",
          "downloadPDF",
          "separator",
          "downloadCSV",
          "downloadXLS"
        )
      )
    ),
    filename = "grafico-isdp"
  )
}