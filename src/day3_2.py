
import re

if __name__ == "__main__":
    with open("inputs/day3_2.test", "r") as file:
        regex = re.compile(r"(do(?:n't)?)\(\).*?((?:(?:mul\(\d+,\d+\)).*?)*?)(?=(?:do(?:n't)?)\(\))")
        contents = file.read()
        matches = regex.findall(contents)
        print(matches)
