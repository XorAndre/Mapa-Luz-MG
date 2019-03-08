class resultSearch
   _map: null
   _infoWindow: null
   
   constructor: (mapID, lat, lng, items) ->
      self = @
      @initMap(mapID, lat, lng)
      @addMaker(item.lat,item.lng, item.content) for item in items
         
      google.maps.event.addListener(@_infoWindow, 'domready', () ->
         jQuery('.infowindow_data_slick').slick({
          infinite: true,
          slidesToShow: 1,
          slidesToScroll: 1,
          prevArrow: '<button type="button" class="slick-prev slick-arrow"><i class="fa fa-chevron-left"></i></button>',
          nextArrow: '<button type="button" class="slick-next slick-arrow"><i class="fa fa-chevron-right"></i></button>'
          
        })
      ) if @_infoWindow
   
      google.maps.event.addListener(@_map, 'click', () ->
         self._infoWindow.close() if self._infoWindow
      )
   
   initMap: (mapID, lat, lng) ->
      options =
         zoom: 8,
         center: new google.maps.LatLng(lat, lng),
         mapTypeId: google.maps.MapTypeId.ROADMAP

      @_map = new google.maps.Map(document.getElementById(mapID), options)
      
   addMaker: (lat,lng, content) ->
      self  = @
      template = @templates(content)
      
      @_marker = new google.maps.Marker({
         position: new google.maps.LatLng(lat,lng),
         map: @_map
      })

      infoWindowListener(self, @_marker, template.slide + template.intro )

   templates: (content) ->
      slideRender = (slides) ->
         ("""<div><img src=#{slide} alt="img"/></div>""" for slide in slides).join('')

      slide: """
         <div class="infowindow_wrapper slider infowindow_data_slick" data-slick>#{slideRender(content.slides)}</div>
      """
      intro: """
         <div class="infowindow_wrapper intro">
            <h4>#{content.title}</h4>
            <p>#{content.summary}</p>
         </div>
      """

   infoWindowListener = (obj, mkr, content) ->
      
      obj._infoWindow = new google.maps.InfoWindow({pixelOffset: new google.maps.Size(5, 20)}) if !obj._infoWindow
         
      google.maps.event.addListener(mkr, 'click', () -> 
         obj._infoWindow.setContent('<div class="infowindow container-fluid">' + content + '</div>')

         obj._infoWindow.open(obj._map, mkr)
         gmStyle = jQuery('.gm-style-iw')
         gmStyle.addClass('custom')
         gmStyle.next().remove()
         gmStyle.prev().remove()
         gmStyle.find('>div').css('overflow', '')
         gmStyle.find('>div').find('>div').css('overflow', '')
      )


#Sample Datas
datas = [{
   lat: -19.7834,
   lng: -45.6814,
   content: {
      title: 'Cidade de Luz-MG',
      summary: 'Luz cidade do Centro Oeste Mineiro',
      slides: ['https://www.ferias.tur.br/imgs/3360/luz/g_luz-mg-monumento-do-rotary-na-entrada-da-cidade-fotorogerio-santos-perei2.jpg']
   }
},
{
   lat: -19.7834,
   lng: -45.6814,
   content: {
      title: 'Luz',
      summary: 'Cidade de Luz-MG',
      slides: ['https://i.ytimg.com/vi/jP8lYyI9ryo/maxresdefault.jpg']
   }
},
{
   lat: -19.7834,
   lng:  -45.6814,
   content: {
      title: 'Luz-MG',
      summary: 'A história inicia-se por volta de 1780 e tem origem no conflito existente entre dois grandes fazendeiros, descendentes de bandeirantes paulistas, em relação à linha divisória de suas terras.

Para que a questão fosse resolvida a contento, a esposa de um deles fez uma promessa à Nossa Senhora da Luz.

Certa manhã, conforme combinaram, os fazendeiros (Coronel Cocais e Coronel Camargos) partem, cada um de sua residência e cavalgam, um em direção ao outro, até se encontrarem próximo ao ribeirão Jorge Pequeno. No local do encontro, fixam o marco divisório e, mandam erigir uma capela em devoção à padroeira Nossa Senhora da Luz. Nas proximidades do local, havia um olho de água, represado por um aterro que abastecia o pequeno povoado formado em volta da capela, o que explica a origem do nome Nossa Senhora da Luz do Aterrado que lhe foi dado.

O ciclo de progresso tem início com a implantação do bispado do Aterrado.

O município se instala em 1923, adotando a denominação de Luz.',
      slides: ['https://mapio.net/images-p/60224279.jpg']
   }
}]

new resultSearch('map-canvas', -19.7834, -45.6814, datas)
