import re

def check(serials, serial_input):
    status = None
    digit_regex = r"\D"

    if len(serial_input) >= 4:
        first_part = serial_input[0:4].upper()
        second_part = serial_input[3:10].upper()
        category_serials = serials.get(first_part)

        if category_serials:
            if len(serial_input) >= 10:
                second_part = re.sub(digit_regex, '0', second_part)
                serial_part = int(second_part)
                for serial in sorted(category_serials.keys()):
                    if serial_part > int(serial):
                        continue
                    else:
                        status = serials.get(first_part, {}).get(serial, 'patched')
                        break

                if status is None:
                    status = 'patched'
            else:
                status = "incorrect"
        else:
            status = "incorrect"
    return status
