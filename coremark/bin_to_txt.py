def bin_to_txt(bin_file_path, txt_file_path):
    with open(bin_file_path, 'rb') as bin_file, open(txt_file_path, 'w') as txt_file:
        while True:
            bytes_chunk = bin_file.read(4)  # 4 bytes = 32 bits
            if len(bytes_chunk) < 4:
                break

            # Little-endian byte order: reverse for easier reading (optional)
            byte_list = list(bytes_chunk)

            # Convert each byte to 8-bit binary string
            binary_bytes = [format(b, '08b') for b in byte_list]
            binary_bytes.reverse()

            # Join with underscores
            formatted_instruction = '_'.join(binary_bytes)

            # Write to output file
            txt_file.write(formatted_instruction + '\n')

# Applying to coremark_bmrk_iram:
bin_to_txt('coremark_bmrk_iram.bin', 'coremark_bmrk_iram.txt')