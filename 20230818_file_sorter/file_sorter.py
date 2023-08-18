import os                                                                       # to get file/path details
import shutil                                                                   # to move them around


def create_folder(path: str, extension: str) -> str:
    """Creates a folder that is named after the extension of the file passed"""
    folder_name: str = extension[1:]                                            # to get everything besides "."
    folder_path: str = os.path.join(path, folder_name)

    if not os.path.exists(folder_path):
       os.makedirs(folder_path)

    return folder_path


def sort_files(source_path: str):
    """Sorts files based on a given path"""

    for root_dir, sub_dir, filenames in os.walk(source_path):
        for filename in filenames:
            file_path: str = os.path.join(root_dir, filename)
            extension: str = os.path.splitext(filename)[1]

            if extension:
                target_folder: str = create_folder(source_path, extension)
                target_path: str = os.path.join(target_folder, filename)
                shutil.move(file_path, target_path)


def remove_empty_folder(source_path: str):
    """Removes all empty folders after files have been moved"""
    for root_dir, sub_dir, filenames in os.walk(source_path, topdown=False):    #topdown = False to start with sub folders
        for current_dir in sub_dir:
            folder_path: str = os.path.join(root_dir, current_dir)

            if not os.listdir(folder_path):
                os.rmdir(folder_path)


def main():
    user_input: str = input("Provide a path for sorting to be performed on... ")

    if os.path.exists(path=user_input):
        sort_files(user_input)
        remove_empty_folder(user_input)
        print('Files have been sorted')

    else:
        print('The path you provided is invalid, please check and provide a valid path.')

if __name__ == '__main__':
    main()