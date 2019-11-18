# O gerenciador de E/S deve ser responsável por administrar a alocação e a liberação de todos os recursos disponíveis, garantindo uso exclusivo dos mesmos. 

# frozen_string_literal: true
class ResourcesManager
  def initialize()
    # Tipos de IO da aplicação, inicializados vazios
    @scanner = Array.new(1)
    @printer = Array.new(2)
    @modem = Array.new(1)
    @sata = Array.new(2)
  end
  
  def allocate_io(process)
    
    free = true
    if process.modem > 0 && @modem[0] != nil
      free = false
    end
    if process.scanner > 0 && @scanner[0] != nil
      free = false
    end
    if process.printer > 0 && @printer[process.printer - 1] != nil
      free = false
    end
    if process.driver > 0 && @sata[process.driver - 1] != nil
      free = false
    end

    if free
      if process.modem > 0
        @modem[0] = process.pid
      end
      if process.scanner > 0
        @scanner[0] = process.pid
      end
      if process.printer > 0
        @printer[process.printer - 1] = process.pid
      end
      if process.driver > 0
        @printer[process.driver - 1] = process.pid
      end
      return true
    else
      return false
    end
  end
    
  def free_io(process)
    if @modem[0] == process.pid
      @modem[0] = nil
    end
    if @scanner[0] == process.pid
      @scanner[0] = nil
    end
    if @printer.include? process.pid
      @printer[process.printer - 1] = nil
    end
    if @sata.include? process.pid
      @sata[process.driver - 1] = nil
    end
  end

  def print_usage
    puts "scanner: #{@scanner}, printer: #{@printer}, modem: #{@modem}, sata: #{@sata}"
  end
  
end
