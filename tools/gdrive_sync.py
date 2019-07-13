#!/usr/bin/env python3

import os
import glob
import time

from collections import namedtuple

from pydrive.auth import GoogleAuth
from pydrive.drive import GoogleDrive
from pydrive.files import FileNotUploadedError


GDRIVE_FILE_TYPE = namedtuple('gdrive_file', ['title', 'id', 'mdate'])


FOLDER_SYN = [
    # TODO: put your to be synced local folder path here
]


FOLDER_MAP = {
    # TODO: put your to be synced local folder path as key and remote Google Drive folder id as value
}


class Google_Drive_Auto_Synchronizer():
    def __init__(self):
        self.drive = self._init_gdrive()


    def _init_gdrive(self):
        gauth = GoogleAuth()
        gauth.CommandLineAuth()
        drive = GoogleDrive(gauth)
        return drive


    def _list_gdrive_files(self, remote_folder):
        folder_query_info = {'q': '"%s" in parents and trashed = false' % remote_folder}
        file_list = self.drive.ListFile(folder_query_info).GetList()
        return [f['title'] for f in file_list if f['mimeType'] != 'application/vnd.google-apps.folder']


    def _list_local_files(self, folder):
        file_path_list = glob.glob(folder + '*')
        return [os.path.basename(fp) for fp in file_path_list if not os.path.isdir(fp)]


    def _get_gdrive_file_info_by_name(self, remote_folder, filename):
        folder_query_info = {'q': '"%s" in parents and trashed = false' % remote_folder}
        file_info_list = self.drive.ListFile(folder_query_info).GetList()
        target_file_list = [f for f in file_info_list if f['title'] == filename]

        if len(target_file_list) == 0:
            return GDRIVE_FILE_TYPE(None, None, None)

        if len(target_file_list) > 1:
            print('More than one file with same filename in %s' % remote_folder)
            return GDRIVE_FILE_TYPE(None, None, None)

        f = target_file_list[0]
        return GDRIVE_FILE_TYPE(f['title'], f['id'], f['modifiedDate'])


    def get_local_file_mdate(self, local_folder, filename):
        local_file_path = local_folder + filename
        local_file_mdate = int(os.path.getmtime(local_file_path))
        return  int(os.path.getmtime(local_file_path))


    def get_remote_file_mdate(self, remote_folder, filename):
        f_mdate = self._get_gdrive_file_info_by_name(remote_folder, filename).mdate
        return int(time.mktime(time.strptime(f_mdate, '%Y-%m-%dT%H:%M:%S.%fZ')))


    def file_classify(self, local_folder):
        local_file_list = self._list_local_files(local_folder)
        gdrive_file_list = self._list_gdrive_files(FOLDER_MAP[local_folder])

        both_exists_list = list(set(local_file_list) & set(gdrive_file_list))
        local_only_list = list(set(local_file_list) - set(both_exists_list))
        gdrive_only_list = list(set(gdrive_file_list) - set(both_exists_list))

        return both_exists_list, local_only_list, gdrive_only_list


    def upload_local_files(self, local_folder, remote_folder, filename):
        folder_parent_info = [{'kind': 'drive#fileLink', 'id': remote_folder}]
        local_file_path = local_folder + filename

        try:
            f_id = self._get_gdrive_file_info_by_name(remote_folder, filename).id
            f = self.drive.CreateFile({'title': filename, 'parents': folder_parent_info, 'id': f_id})
            f.SetContentFile(local_file_path)
            f.Upload()
        except FileNotFoundError:
            print('(%s) not found on local host (%s)' % (filename, local_file_path))


    def download_remote_files(self, local_folder, remote_folder, filename):
        folder_parent_info = [{'kind': 'drive#fileLink', 'id': remote_folder}]
        local_file_path = local_folder + filename

        try:
            f_id = self._get_gdrive_file_info_by_name(remote_folder, filename).id
            f = self.drive.CreateFile({'title': filename, 'parents': folder_parent_info, 'id': f_id})
            f.GetContentFile(local_file_path)
        except FileNotUploadedError:
            print('(%s) not found on Google Drive (%s)' % (filename, remote_folder))


    def modify_local_file_mdate(self, local_file_path, second_mtime):
        os.utime(local_file_path, (second_mtime, second_mtime))


    def sync_local_only_files(self, local_folder, remote_folder, local_file_list):
        for filename in local_file_list:
            self.upload_local_files(local_folder, remote_folder, filename)

            # Align USA time to TW time (8 hours)
            f_mdate = self.get_remote_file_mdate(remote_folder, filename) + 28800

            self.modify_local_file_mdate(local_folder + filename, f_mdate)


    def sync_remote_only_files(self, local_folder, remote_folder, remote_file_list):
        for filename in remote_file_list:
            self.download_remote_files(local_folder, remote_folder, filename)

            # Align USA time to TW time (8 hours)
            f_mdate = self.get_remote_file_mdate(remote_folder, filename) + 28800

            # Modify local file mdate rather than remote file mdate
            self.modify_local_file_mdate(local_folder + filename, f_mdate)


    def sync_both_exists_files(self, local_folder, remote_folder, both_exists_list):
        for filename in both_exists_list:
            local_file_mdate = self.get_local_file_mdate(local_folder, filename)

            # Align USA time to TW time (8 hours)
            remote_file_mdate = self.get_remote_file_mdate(remote_folder, filename) + 28800

            if abs(local_file_mdate - remote_file_mdate) < 60:
                continue
            elif local_file_mdate > remote_file_mdate:
                self.upload_local_files(local_folder, remote_folder, filename)

                # Align USA time to TW time (8 hours)
                f_mdate = self.get_remote_file_mdate(remote_folder, filename) + 28800

                self.modify_local_file_mdate(local_folder + filename, f_mdate)
            else:
                self.download_remote_files(local_folder, remote_folder, filename)

                # Align USA time to TW time (8 hours)
                f_mdate = self.get_remote_file_mdate(remote_folder, filename) + 28800

                # Modify local file mdate rather than remote file mdate
                self.modify_local_file_mdate(local_folder + filename, f_mdate)


    def sync_files(self):
        for folder in FOLDER_SYN:
            both_exists_list, local_only_list, gdrive_only_list = self.file_classify(folder)

            self.sync_local_only_files(folder, FOLDER_MAP[folder], local_only_list)
            self.sync_remote_only_files(folder, FOLDER_MAP[folder], gdrive_only_list)
            self.sync_both_exists_files(folder, FOLDER_MAP[folder], both_exists_list)


if __name__ == '__main__':
    sync = Google_Drive_Auto_Synchronizer()
    sync.sync_files()
