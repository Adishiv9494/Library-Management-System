<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/x-icon" href="logo2.jpg">
    <title>Report - Library Management</title>
    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- SweetAlert2 -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
    <style>
        :root {
            --bg-color: #f8f9fa;
            --card-bg: #ffffff;
            --text-color: #212529;
            --header-bg: linear-gradient(135deg, #4e73df, #224abe);
            --shadow: rgba(0,0,0,0.1);
            --border-color: #dee2e6;
        }
        [data-theme="dark"] {
            --bg-color: #1a1a2e;
            --card-bg: #16213e;
            --text-color: #f8f9fa;
            --header-bg: linear-gradient(135deg, #1e3a8a, #1e40af);
            --shadow: rgba(255,255,255,0.05);
            --border-color: #495057;
        }
        body {
            background: var(--bg-color);
            color: var(--text-color);
            transition: all 0.3s ease;
            min-height: 100vh;
        }
        .header {
            background: var(--header-bg);
            color: white;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 40px;
            position: relative;
            box-shadow: 0 4px 20px rgba(0,0,0,0.2);
        }
        .header h1 { font-size: 2rem; }
        .header p { opacity: 0.9; }
        .back-button, .theme-toggle {
            position: absolute;
            top: 20px;
            background: rgba(255,255,255,0.2);
            border: none;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            color: white;
            font-size: 1.2rem;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s;
        }
        .back-button { left: 20px; }
        .theme-toggle { right: 20px; }
        .back-button:hover, .theme-toggle:hover { background: rgba(255,255,255,0.3); }
        .section-title {
            color: var(--text-color);
            margin-bottom: 25px;
            font-weight: 600;
            border-left: 4px solid #4e73df;
            padding-left: 15px;
        }
        .card {
            background: var(--card-bg);
            color: var(--text-color);
            border: none;
            border-radius: 15px;
            box-shadow: 0 6px 10px var(--shadow);
            transition: all 0.3s;
            height: 100%;
            text-align: center;
            padding: 1.5rem;
        }
        .card:hover { transform: translateY(-5px); box-shadow: 0 12px 20px var(--shadow); }
        .card-icon { font-size: 2.5rem; margin-bottom: 15px; }
        .import-card .card-icon { color: #4e73df; }
        .defaulter-card .card-icon { color: #e74a3b; }
        .fine-card .card-icon { color: #f6c23e; }
        .books-card .card-icon { color: #1cc88a; }
        .issuedbooks-card .card-icon { color: #36b9cc; }
        .btn-custom {
            border-radius: 50px;
            padding: 8px 20px;
            font-weight: 500;
            border: none;
            color: white;
            transition: all 0.3s;
        }
        .btn-custom:hover { transform: translateY(-2px); }
        .btn-import { background: linear-gradient(135deg, #4e73df, #224abe); }
        .btn-import:disabled { background: #6c757d; cursor: not-allowed; }
        .btn-defaulter { background: linear-gradient(135deg, #e74a3b, #be2617); }
        .btn-fine { background: linear-gradient(135deg, #f6c23e, #dda20a); }
        .btn-books { background: linear-gradient(135deg, #1cc88a, #13855c); }
        .btn-issuedbooks { background: linear-gradient(135deg, #36b9cc, #258391); }

        /* Custom file input styled as a button */
        .file-upload-wrapper {
            position: relative;
            display: inline-block;
            width: 100%;
            margin-bottom: 15px;
        }
        .file-upload-wrapper input[type="file"] {
            position: absolute;
            left: 0;
            top: 0;
            opacity: 0;
            width: 100%;
            height: 100%;
            cursor: pointer;
        }
        .file-upload-btn {
            display: block;
            padding: 8px 15px;
            background: rgba(78, 115, 223, 0.1);
            border: 2px dashed var(--border-color);
            border-radius: 8px;
            text-align: center;
            color: var(--text-color);
            transition: all 0.3s;
            font-weight: 500;
            cursor: pointer;
        }
        .file-upload-btn:hover {
            background: rgba(78, 115, 223, 0.2);
        }
        .file-upload-btn i { margin-right: 8px; }
        .file-upload-btn .file-name {
            display: inline-block;
            max-width: 150px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            vertical-align: middle;
        }
        .file-upload-wrapper.file-selected .file-upload-btn {
            border-style: solid;
            border-color: #4e73df;
            background: rgba(78, 115, 223, 0.1);
        }
        .file-info {
            font-size: 12px;
            color: #6c757d;
            margin-top: 5px;
            display: none;
        }
        .file-selected .file-info { display: block; }
        [data-theme="dark"] .file-info { color: #aaa; }

        .col-custom-4 { flex: 0 0 33.333333%; max-width: 33.333333%; }
        @media (max-width: 992px) { .col-custom-4 { flex: 0 0 50%; max-width: 50%; } }
        @media (max-width: 576px) { .col-custom-4 { flex: 0 0 100%; max-width: 100%; } }
    </style>
</head>
<body>
    <div class="container py-4">
        <!-- Header -->
        <div class="header">
            <!-- Back button – always goes to Dashboard.jsp -->
            <button class="back-button" onclick="window.location.href='Dashboard.jsp'"><i class="fas fa-arrow-left"></i></button>
            <button class="theme-toggle" id="themeToggle"><i class="fas fa-moon"></i></button>
            <h1 class="text-center"><i class="fas fa-user-graduate me-2"></i> Student Data Management</h1>
            <p class="text-center mb-0">Manage all student records, defaulters and pending fines</p>
        </div>

        <!-- Data Import Section -->
        <h4 class="section-title">Data Import</h4>
        <div class="row">
            <!-- BCA -->
            <div class="col-custom-4 col-md-6 mb-4">
                <form action="BCAStudents" method="post" enctype="multipart/form-data" class="import-form">
                    <input type="hidden" name="department" value="BCA">
                    <div class="card import-card">
                        <div class="card-body">
                            <div class="card-icon"><i class="fas fa-laptop-code"></i></div>
                            <h5 class="card-title">BCA Students</h5>
                            <p class="card-text">Import Bachelor of Computer Applications records</p>
                            <div class="file-upload-wrapper" id="bcaWrapper">
                                <input type="file" id="bcaFile" name="file" accept=".xlsx,.xls,.csv" required>
                                <label for="bcaFile" class="file-upload-btn" id="bcaLabel">
                                    <i class="fas fa-cloud-upload-alt"></i>
                                    <span class="file-name" id="bcaFileName">Choose file</span>
                                </label>
                                <div class="file-info" id="bcaInfo"></div>
                            </div>
                            <button type="submit" id="bcaBtn" class="btn-custom btn-import" disabled>
                                <i class="fas fa-upload me-2"></i>Import
                            </button>
                        </div>
                    </div>
                </form>
            </div>

            <!-- BBA -->
            <div class="col-custom-4 col-md-6 mb-4">
                <form action="BBAStudents" method="post" enctype="multipart/form-data" class="import-form">
                    <input type="hidden" name="department" value="BBA">
                    <div class="card import-card">
                        <div class="card-body">
                            <div class="card-icon"><i class="fas fa-briefcase"></i></div>
                            <h5 class="card-title">BBA Students</h5>
                            <p class="card-text">Import Bachelor of Business Administration records</p>
                            <div class="file-upload-wrapper" id="bbaWrapper">
                                <input type="file" id="bbaFile" name="file" accept=".xlsx,.xls,.csv" required>
                                <label for="bbaFile" class="file-upload-btn" id="bbaLabels">
                                    <i class="fas fa-cloud-upload-alt"></i>
                                    <span class="file-name" id="bbaFileName">Choose file</span>
                                </label>
                                <div class="file-info" id="bbaInfo"></div>
                            </div>
                            <button type="submit" id="bbaBtn" class="btn-custom btn-import" disabled>
                                <i class="fas fa-upload me-2"></i>Import
                            </button>
                        </div>
                    </div>
                </form>
            </div>

            <!-- B.Tech -->
            <div class="col-custom-4 col-md-6 mb-4">
                <form action="BtechStudents" method="post" enctype="multipart/form-data" class="import-form">
                    <input type="hidden" name="department" value="BTECH">
                    <div class="card import-card">
                        <div class="card-body">
                            <div class="card-icon"><i class="fas fa-microchip"></i></div>
                            <h5 class="card-title">B.Tech Students</h5>
                            <p class="card-text">Import Bachelor of Technology records</p>
                            <div class="file-upload-wrapper" id="btechWrapper">
                                <input type="file" id="btechFile" name="file" accept=".xlsx,.xls,.csv" required>
                                <label for="btechFile" class="file-upload-btn" id="btechLabel">
                                    <i class="fas fa-cloud-upload-alt"></i>
                                    <span class="file-name" id="btechFileName">Choose file</span>
                                </label>
                                <div class="file-info" id="btechInfo"></div>
                            </div>
                            <button type="submit" id="btechBtn" class="btn-custom btn-import" disabled>
                                <i class="fas fa-upload me-2"></i>Import
                            </button>
                        </div>
                    </div>
                </form>
            </div>

            <!-- MCA -->
            <div class="col-custom-4 col-md-6 mb-4">
                <form action="MCAStudents" method="post" enctype="multipart/form-data" class="import-form">
                    <input type="hidden" name="department" value="MCA">
                    <div class="card import-card">
                        <div class="card-body">
                            <div class="card-icon"><i class="fas fa-graduation-cap"></i></div>
                            <h5 class="card-title">MCA Students</h5>
                            <p class="card-text">Import Master of Computer Applications records</p>
                            <div class="file-upload-wrapper" id="mcaWrapper">
                                <input type="file" id="mcaFile" name="file" accept=".xlsx,.xls,.csv" required>
                                <label for="mcaFile" class="file-upload-btn" id="mcaLabel">
                                    <i class="fas fa-cloud-upload-alt"></i>
                                    <span class="file-name" id="mcaFileName">Choose file</span>
                                </label>
                                <div class="file-info" id="mcaInfo"></div>
                            </div>
                            <button type="submit" id="mcaBtn" class="btn-custom btn-import" disabled>
                                <i class="fas fa-upload me-2"></i>Import
                            </button>
                        </div>
                    </div>
                </form>
            </div>

            <!-- MBA -->
            <div class="col-custom-4 col-md-6 mb-4">
                <form action="MBAStudents" method="post" enctype="multipart/form-data" class="import-form">
                    <input type="hidden" name="department" value="MBA">
                    <div class="card import-card">
                        <div class="card-body">
                            <div class="card-icon"><i class="fas fa-chart-line"></i></div>
                            <h5 class="card-title">MBA Students</h5>
                            <p class="card-text">Import Master of Business Administration records</p>
                            <div class="file-upload-wrapper" id="mbaWrapper">
                                <input type="file" id="mbaFile" name="file" accept=".xlsx,.xls,.csv" required>
                                <label for="mbaFile" class="file-upload-btn" id="mbaLabel">
                                    <i class="fas fa-cloud-upload-alt"></i>
                                    <span class="file-name" id="mbaFileName">Choose file</span>
                                </label>
                                <div class="file-info" id="mbaInfo"></div>
                            </div>
                            <button type="submit" id="mbaBtn" class="btn-custom btn-import" disabled>
                                <i class="fas fa-upload me-2"></i>Import
                            </button>
                        </div>
                    </div>
                </form>
            </div>

            <!-- Polytechnic -->
            <div class="col-custom-4 col-md-6 mb-4">
                <form action="PtechStudents" method="post" enctype="multipart/form-data" class="import-form">
                    <input type="hidden" name="department" value="POLY">
                    <div class="card import-card">
                        <div class="card-body">
                            <div class="card-icon"><i class="fas fa-tools"></i></div>
                            <h5 class="card-title">Polytechnic</h5>
                            <p class="card-text">Import Polytechnic/Diploma student records</p>
                            <div class="file-upload-wrapper" id="polyWrapper">
                                <input type="file" id="polyFile" name="file" accept=".xlsx,.xls,.csv" required>
                                <label for="polyFile" class="file-upload-btn" id="polyLabel">
                                    <i class="fas fa-cloud-upload-alt"></i>
                                    <span class="file-name" id="polyFileName">Choose file</span>
                                </label>
                                <div class="file-info" id="polyInfo"></div>
                            </div>
                            <button type="submit" id="polyBtn" class="btn-custom btn-import" disabled>
                                <i class="fas fa-upload me-2"></i>Import
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <!-- Student Management Section -->
        <h4 class="section-title mt-5">Student Management</h4>
        <div class="row">
            <!-- Defaulters -->
            <div class="col-lg-3 col-md-6 mb-4">
                <div class="card defaulter-card">
                    <div class="card-body">
                        <div class="card-icon"><i class="fas fa-user-clock"></i></div>
                        <h5 class="card-title">Defaulters</h5>
                        <p class="card-text">View late book submissions</p>
                        <a href="Defaulter.jsp" class="btn-custom btn-defaulter"><i class="fas fa-list me-2"></i>View</a>
                    </div>
                </div>
            </div>

            <!-- Pending Fines -->
            <div class="col-lg-3 col-md-6 mb-4">
                <div class="card fine-card">
                    <div class="card-body">
                        <div class="card-icon"><i class="fas fa-money-bill-wave"></i></div>
                        <h5 class="card-title">Pending Fines</h5>
                        <p class="card-text">Students with unpaid fines</p>
                        <a href="PendingFine.jsp" class="btn-custom btn-fine"><i class="fas fa-eye me-2"></i>View</a>
                    </div>
                </div>
            </div>

            <!-- Import Books -->
            <div class="col-lg-3 col-md-6 mb-4">
                <form action="BooksImportData" method="post" enctype="multipart/form-data" class="import-form">
                    <input type="hidden" name="department" value="Books">
                    <div class="card books-card">
                        <div class="card-body">
                            <div class="card-icon"><i class="fas fa-book"></i></div>
                            <h5 class="card-title">Import Books</h5>
                            <p class="card-text">Import book records to the library</p>
                            <div class="file-upload-wrapper" id="booksWrapper">
                                <input type="file" id="booksFile" name="file" accept=".xlsx,.xls,.csv" required>
                                <label for="booksFile" class="file-upload-btn" id="booksLabel">
                                    <i class="fas fa-cloud-upload-alt"></i>
                                    <span class="file-name" id="booksFileName">Choose file</span>
                                </label>
                                <div class="file-info" id="booksInfo"></div>
                            </div>
                            <button type="submit" id="booksBtn" class="btn-custom btn-books" disabled>
                                <i class="fas fa-upload me-2"></i>Import
                            </button>
                        </div>
                    </div>
                </form>
            </div>

            <!-- Issued Books -->
            <div class="col-lg-3 col-md-6 mb-4">
                <div class="card issuedbooks-card">
                    <div class="card-body">
                        <div class="card-icon"><i class="fas fa-book-reader"></i></div>
                        <h5 class="card-title">Issued Books</h5>
                        <p class="card-text">View all issued book records</p>
                        <a href="AllIssuedBooks.jsp" class="btn-custom btn-issuedbooks"><i class="fas fa-list me-2"></i>View</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
        (function() {
            // Theme toggle
            const toggleBtn = document.getElementById('themeToggle');
            const iconEl = toggleBtn.querySelector('i');
            if (localStorage.getItem('theme') === 'dark') {
                document.documentElement.setAttribute('data-theme', 'dark');
                iconEl.classList.remove('fa-moon');
                iconEl.classList.add('fa-sun');
            }
            toggleBtn.addEventListener('click', function() {
                const current = document.documentElement.getAttribute('data-theme');
                if (current === 'dark') {
                    document.documentElement.removeAttribute('data-theme');
                    localStorage.setItem('theme', 'light');
                    iconEl.classList.remove('fa-sun');
                    iconEl.classList.add('fa-moon');
                } else {
                    document.documentElement.setAttribute('data-theme', 'dark');
                    localStorage.setItem('theme', 'dark');
                    iconEl.classList.remove('fa-moon');
                    iconEl.classList.add('fa-sun');
                }
            });

            // File input handler with button-style label
            function setupFileInput(fileId, labelId, fileNameId, infoId, btnId) {
                const fileInput = document.getElementById(fileId);
                const label = document.getElementById(labelId);
                const fileName = document.getElementById(fileNameId);
                const info = document.getElementById(infoId);
                const btn = document.getElementById(btnId);
                const wrapper = fileInput.closest('.file-upload-wrapper');

                fileInput.addEventListener('change', function() {
                    if (this.files.length > 0) {
                        const file = this.files[0];
                        // Show file name
                        fileName.textContent = file.name;
                        // Show file info
                        info.textContent = 'Size: ' + (file.size / 1024).toFixed(2) + ' KB | Type: ' + file.type.split('/').pop().toUpperCase();
                        info.style.display = 'block';
                        // Enable import button
                        btn.disabled = false;
                        // Add selected class
                        wrapper.classList.add('file-selected');
                    } else {
                        fileName.textContent = 'Choose file';
                        info.style.display = 'none';
                        btn.disabled = true;
                        wrapper.classList.remove('file-selected');
                    }
                });
            }

            setupFileInput('bcaFile', 'bcaLabel', 'bcaFileName', 'bcaInfo', 'bcaBtn');
            setupFileInput('bbaFile', 'bbaLabels', 'bbaFileName', 'bbaInfo', 'bbaBtn');
            setupFileInput('btechFile', 'btechLabel', 'btechFileName', 'btechInfo', 'btechBtn');
            setupFileInput('mcaFile', 'mcaLabel', 'mcaFileName', 'mcaInfo', 'mcaBtn');
            setupFileInput('mbaFile', 'mbaLabel', 'mbaFileName', 'mbaInfo', 'mbaBtn');
            setupFileInput('polyFile', 'polyLabel', 'polyFileName', 'polyInfo', 'polyBtn');
            setupFileInput('booksFile', 'booksLabel', 'booksFileName', 'booksInfo', 'booksBtn');

            // Form submit with SweetAlert confirmation
            document.querySelectorAll('.import-form').forEach(function(form) {
                form.addEventListener('submit', function(e) {
                    e.preventDefault();
                    const fileInput = this.querySelector('input[type="file"]');
                    if (!fileInput.files.length) {
                        Swal.fire({
                            title: 'No File Selected',
                            text: 'Please select a file to import.',
                            icon: 'error',
                            confirmButtonText: 'OK'
                        });
                        return;
                    }
                    const department = this.querySelector('input[name="department"]').value || 'Data';
                    Swal.fire({
                        title: 'Import ' + department + '?',
                        text: 'This will import all records from the selected file. Continue?',
                        icon: 'question',
                        showCancelButton: true,
                        confirmButtonColor: '#4e73df',
                        cancelButtonColor: '#e74a3b',
                        confirmButtonText: 'Yes, import!',
                        cancelButtonText: 'Cancel'
                    }).then(function(result) {
                        if (result.isConfirmed) {
                            form.submit();
                        }
                    });
                });
            });
        })();
    </script>
</body>
</html>