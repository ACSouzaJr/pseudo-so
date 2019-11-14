# O gerenciador de E/S deve ser responsável por administrar a alocação e a liberação de todos os recursos disponíveis, garantindo uso exclusivo dos mesmos. 

# frozen_string_literal: true
class Resources
  def allocate_io(process)
    # Tipos de IO da aplicação, inicializados vazios
    scanner = []
    printer = []
    modem = []
    sata = []
    free = true

    if process[@requisicao_modem] > 0 && modem[0] != nil
      free = false
    end
    if process[@requisicao_scanner] > 0 && scanner[0] != nil
      free = false
    end
    if process[@numero_impressora] > 0 && printer[process[numero_impressora] - 1] != nil
      free = false
    end
    if process[@numero_disco] > 0 && sata[process[numero_disco] - 1] != nil
      free = false
    end

    if free
      if process[@requisicao_modem] > 0
        modem[0] = process[@pid]
      end
      if process[@requisicao_scanner] > 0
        scanner[0] = process[@pid]
      end
      if process[@numero_impressora] > 0
        printer[process[@numero_impressora] - 1] = process[@pid]
      end
      if process[@numero_disco] > 0
        printer[process[@numero_disco] - 1] = process[@pid]
      end
      return true
    else
      return false
    end
  end
    
  def free_io(process)
    if modem[0] == process[@pid]
      modem[0] = nil
    end
    if scanner[0] == process[@pid]
      scanner[0] = nil
    end
    if printer.include? process[@pid]
      printer[process[@numero_impressora] - 1] = nil
    end
    if sata.include? process[@pid]
      sata[process[@numero_disco] - 1] = nil
    end
  end
end
