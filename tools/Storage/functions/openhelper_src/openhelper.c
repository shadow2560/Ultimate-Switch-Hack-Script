/* openhelper.c
   Helper to select file or folder and output UTF-8 path
   Usage:
	 vbs_openhelper.exe file "<initialDir>" "<filter>" "<title>"
	 vbs_openhelper.exe folder [interface] "<initialDir>" "<title>"
	 - interface: "shbrowse" or "ifiledialog" (optional)
	 - filter uses GetOpenFileNameW filter format: "Description\0*.ext\0All files\0*.*\0\0"
	 - All arguments are expected UTF-8 on the command line; we convert to wide.
*/

#define _CRT_SECURE_NO_WARNINGS
#include <windows.h>
#include <commdlg.h>
#include <shlobj.h>
#include <shobjidl.h>
#include <stdio.h>
#include <wchar.h>
#include <stdlib.h>

static wchar_t* prepare_filter(const wchar_t* src) {
    if (!src) return NULL;

    size_t len = wcslen(src);
    wchar_t* buf = (wchar_t*)malloc((2*len + 2) * sizeof(wchar_t));
    if (!buf) return NULL;

    size_t i = 0;
    while (*src) {
        wchar_t c = *src++;
        if (c == L'^' || c == L'<' || c == L'>' || c == L':' || c == L'"' ||
            c == L'/' || c == L'\\' || c == L'?') {
            continue;
        }
        if (c == L'|') {
            buf[i++] = 0;
        } else {
            buf[i++] = c;
        }
    }
    buf[i++] = 0;
    buf[i] = 0;

    return buf;
}

static void print_utf8(const wchar_t* wstr) {
	if (!wstr) return;
	int n = WideCharToMultiByte(CP_UTF8, 0, wstr, -1, NULL, 0, NULL, NULL);
	if (n>0) {
		char* out = (char*)malloc(n);
		WideCharToMultiByte(CP_UTF8, 0, wstr, -1, out, n, NULL, NULL);
		printf("%s", out);
		free(out);
	}
}

// --- SHBrowseForFolder folder selection ---
static int select_folder_shbrowse(const wchar_t* initDir, const wchar_t* title, wchar_t* outPath, int maxLen) {
	int ret = 0;
	BROWSEINFOW bi;
	ZeroMemory(&bi, sizeof(bi));
	bi.hwndOwner = NULL;
	bi.lpszTitle = title ? title : L"Select folder";
	bi.ulFlags = BIF_RETURNONLYFSDIRS | BIF_NEWDIALOGSTYLE;

	int CALLBACK BrowseCallbackProc(HWND hwnd, UINT uMsg, LPARAM lParam, LPARAM lpData) {
		if (uMsg == BFFM_INITIALIZED && lpData) {
			SendMessage(hwnd, BFFM_SETSELECTIONW, TRUE, lpData);
		}
		return 0;
	}
	bi.lpfn = BrowseCallbackProc;
	bi.lParam = (LPARAM)initDir;

	LPITEMIDLIST pidl = SHBrowseForFolderW(&bi);
	if (pidl) {
		if (SHGetPathFromIDListW(pidl, outPath))
			ret = 1;
		CoTaskMemFree(pidl);
	}
	return ret;
}

// --- IFileDialog folder selection (modern) ---
static int select_folder_ifd(const wchar_t* initDir, const wchar_t* title, wchar_t* outPath, int maxLen) {
	int ret = 0;
	HRESULT hr = CoInitializeEx(NULL, COINIT_APARTMENTTHREADED);
	if (FAILED(hr)) return 0;

	IFileDialog *pfd = NULL;
	hr = CoCreateInstance(&CLSID_FileOpenDialog, NULL, CLSCTX_INPROC_SERVER, &IID_IFileDialog, (void**)&pfd);
	if (SUCCEEDED(hr) && pfd) {
		DWORD options;
		if (SUCCEEDED(pfd->lpVtbl->GetOptions(pfd, &options)))
			pfd->lpVtbl->SetOptions(pfd, options | FOS_PICKFOLDERS);

		if (initDir && initDir[0]) {
			IShellItem *psi = NULL;
			if (SUCCEEDED(SHCreateItemFromParsingName(initDir, NULL, &IID_IShellItem, (void**)&psi)) && psi) {
				pfd->lpVtbl->SetDefaultFolder(pfd, psi);
				pfd->lpVtbl->SetFolder(pfd, psi);
				psi->lpVtbl->Release(psi);
			}
		}
		if (title && title[0]) pfd->lpVtbl->SetTitle(pfd, title);
		if (SUCCEEDED(pfd->lpVtbl->Show(pfd, NULL))) {
			IShellItem *psiResult = NULL;
			if (SUCCEEDED(pfd->lpVtbl->GetResult(pfd, &psiResult)) && psiResult) {
				PWSTR wpath = NULL;
				if (SUCCEEDED(psiResult->lpVtbl->GetDisplayName(psiResult, SIGDN_FILESYSPATH, &wpath)) && wpath) {
					wcsncpy(outPath, wpath, maxLen-1);
					outPath[maxLen-1] = 0;
					CoTaskMemFree(wpath);
					ret = 1;
				}
				psiResult->lpVtbl->Release(psiResult);
			}
		}
		pfd->lpVtbl->Release(pfd);
	}
	CoUninitialize();
	return ret;
}

// --- File selection ---
static int select_file(const wchar_t* initDir, const wchar_t* filter, const wchar_t* title, wchar_t* outPath, int maxLen) {
	int ret = 0;
	OPENFILENAMEW ofn;
	wchar_t filebuf[32768];
	ZeroMemory(&ofn, sizeof(ofn));
	filebuf[0] = 0;
	ofn.lStructSize = sizeof(ofn);
	ofn.hwndOwner = NULL;
	ofn.lpstrFile = filebuf;
	ofn.nMaxFile = sizeof(filebuf)/sizeof(filebuf[0]);
	ofn.lpstrInitialDir = initDir;
	wchar_t* filterbuf = prepare_filter(filter);
	if (filterbuf) {
		ofn.lpstrFilter = filterbuf;
	} else {
		ofn.lpstrFilter = filter;
	}
	ofn.lpstrTitle = title;
	ofn.Flags = OFN_PATHMUSTEXIST | OFN_FILEMUSTEXIST | OFN_EXPLORER;
	if (GetOpenFileNameW(&ofn)) {
		wcsncpy(outPath, filebuf, maxLen-1);
		outPath[maxLen-1] = 0;
		ret = 1;
	}
	free(filterbuf);
	return ret;
}

// --- Main ---
int wmain(int argc, wchar_t** argv_w) {
	int ret = 0;
	if (argc < 2) return 0;
	wchar_t outPath[32768]; outPath[0]=0;

	if (lstrcmpiW(argv_w[1], L"file")==0) {
		const wchar_t* initDir = (argc>=3)?argv_w[2]:L"";
		const wchar_t* filter  = (argc>=4)?argv_w[3]:L"";
		const wchar_t* title   = (argc>=5)?argv_w[4]:L"";
		if (select_file(initDir, filter, title, outPath, 32768))
			print_utf8(outPath);

	} else if (lstrcmpiW(argv_w[1], L"folder")==0) {
		// check optional interface parameter
		const wchar_t* iface = NULL;
		const wchar_t* initDir = NULL;
		const wchar_t* title   = NULL;
		if (argc>=4) {
			if (lstrcmpiW(argv_w[2], L"shbrowse")==0 || lstrcmpiW(argv_w[2], L"ifiledialog")==0) {
				iface = argv_w[2];
				initDir = (argc>=4)?argv_w[3]:L"";
				title   = (argc>=5)?argv_w[4]:L"Select folder";
			} else {
				iface = NULL;
				initDir = argv_w[2];
				title   = (argc>=3)?argv_w[3]:L"Select folder";
			}
		} else {
			initDir = (argc>=3)?argv_w[2]:L"";
			title   = (argc>=4)?argv_w[3]:L"Select folder";
		}

		int ok = 0;
		if (!iface || lstrcmpiW(iface,L"shbrowse")==0) ok = select_folder_shbrowse(initDir, title, outPath, 32768);
		else if (lstrcmpiW(iface,L"ifiledialog")==0) ok = select_folder_ifd(initDir, title, outPath, 32768);
		if (ok) print_utf8(outPath);
	}

	return ret;
}
