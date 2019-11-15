# E o gerenciador de arquivos deve permitir que os processos possam criar e deletar arquivos, de acordo com o modelo de alocação determinado.

# frozen_string_literal: true

class DiskFile
  def initialize(name, first_block, block_count, owner)
    @name = name
    @first_block = first_block
    @block_count = block_count
    @owner = owner
  end
end

class FileManager
  
  def initialize(disk_size)
    # Set disk size
    @disk = Array.new(disk_size, 0)
    @all_files = {}
  end

  def initialize_disk(file_name, offset, block_count)
    block_count.to_i.times do |block|
      @disk[offset.to_i + block] = file_name
    end
    @all_files[file_name] = DiskFile.new(file_name, offset, block_count, nil)
  end

  def create_file(pid, file_name, block_count)
    # posição inicial
    offset = 0
    # espaço disponível
    allocable_files = 0

    # Procura se o arquivo já existe
    if (@disk.key? file_name)
      puts 'O arquivo já está na memória'
    end

    # Localiza espaco disponivel com First Fit e armazena

    @disk.length.times do |i|
      block = @disk[i]
      # Se o bloco estiver vazio
      if block == 0
        allocable_files += 1
        # Se o tamanho disponível for suficiente
        if allocable_files == block_count
          offset = i - allocable_files + 1
          @disk[offset..(offset + allocable_files)] = block_count * [nome]
          @all_files[file_name] = DiskFile.new(file_name, offset, block_count, pid)
          puts 'O processo {} criou o arquivo {} (blocos {})'
        end
      else
        allocable_files = 0
      end
      puts 'O processo {} nao criou o arquivo {} (Sem espaco livre)'
    end
  end

  def delete_file(file_name)
    all_files.key? file_name
    disk[first_block..(block_count + first_block)] = block_count * [0]
  end
end
