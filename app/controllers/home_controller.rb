class HomeController < ApplicationController
  def index
    require 'rpi_gpio'
    
    RPi::GPIO.set_numbering :bcm
    
    @out = Out.all.order(:number)
    
    @out.each do |o|
      RPi::GPIO.setup convert(o.number), :as => :output, :initialize => :low
      if o.active
        RPi::GPIO.set_high convert(o.number)
      else
        RPi::GPIO.set_low convert(o.number)
      end
      end
  end
  
  def edit
    @out = Out.find(params[:id])
  end
  


  def new
    redirect_to home_index_path, alert: "Nie ma więcej wolnych wyjść!" if Out.all.size == 8
    @out = Out.new
  end
  
  def create
    @params = params[:out]    
    
    @out = Out.new(
      name: @params[:name],
      active: false,
      typeof: @params[:typeof],
      number: @params[:number].to_i
    )
    
    if @out.save
      redirect_to home_index_path, notice: "Dodano pomyślnie!"
    else
      redirect_to new_home_path, alert: "Polę nazwa nie może być puste!"
    end
  end
  
  def destroy
    reset (Out.find(params[:id]).number)
    Out.destroy(params[:id])
    redirect_to home_index_path, notice: "Usunięto pomyślnie!"
  end
  
  def update
    if params[:commit].present?
    
      @params = params[:out] 
      
      @out = Out.find(params[:id])
  
      reset(@out.number) if @out.number != @params[:number].to_i
      
      if @out.update(
          name: @params[:name],
          active: on?(@params[:string]),
          typeof: @params[:typeof],
          number: @params[:number].to_i
        ) 
        redirect_to home_index_path, notice: "Zaktualizowano pomyślnie!" 
      else
        redirect_to edit_home_path(params[:id]), alert: "Polę nazwa nie może być puste"
      end
      
    else
      @out = Out.find(params[:id]) 
      @out.active = !@out.active
      @out.save
      redirect_to home_index_path
    end


  end
  
  def info
  end
    
  private
  
  def reset(number)
    require 'rpi_gpio'
      RPi::GPIO.set_numbering :bcm
      RPi::GPIO.setup convert(number), :as => :output
      RPi::GPIO.set_low convert(number)
  end
  
  def convert(number)
    case number
    when 1
      23
    when 2
      27
    when 3
      17
    when 4
      18
    when 5
      16
    when 6
      19
    when 7
      20
    when 8
      26
    end
  end
  
  def on?(state)
    state == "Włączony" ? true : false
  end

end
