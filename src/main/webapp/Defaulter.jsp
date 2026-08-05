<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en" data-bs-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/x-icon" href="logo2.jpg">
    <title>Defaulter Students</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
    <style>
        :root { --primary-color: #4e73df; --secondary-color: #858796; --danger-color: #e74a3b; }
        [data-bs-theme="dark"] { --bs-body-bg: #1a1a2e; --bs-body-color: #f8f9fa; --card-bg: #16213e; }
        [data-bs-theme="light"] { --bs-body-bg: #f8f9fa; --bs-body-color: #212529; --card-bg: #ffffff; }
        body { background-color: var(--bs-body-bg); color: var(--bs-body-color); transition: all 0.3s ease; }
        .card { background-color: var(--card-bg); border: none; border-radius: 0.75rem; box-shadow: 0 0.25rem 0.75rem rgba(0,0,0,0.1); }
        .table th { background-color: var(--danger-color); color: white; }
        .defaulter-badge { background-color: var(--danger-color); color: white; padding: 0.25rem 0.5rem; border-radius: 0.25rem; font-size: 0.75rem; font-weight: bold; }
        .back-btn:hover { transform: translateX(-3px); transition: all 0.3s; }
        .theme-toggle:hover { transform: rotate(15deg); transition: all 0.3s; }
        @media print { .no-print { display: none !important; } }
    </style>
</head>
<body>
    <div class="container py-4">
        <div class="row mb-4">
            <div class="col-12">
                <div class="d-flex justify-content-between align-items-center">
                    <button class="btn btn-outline-primary back-btn no-print" onclick="window.history.back()">
                        <i class="fas fa-arrow-left me-2"></i>Back
                    </button>
                    <h2 class="text-center mb-0 fw-bold" style="color: var(--danger-color);">
                        <i class="fas fa-exclamation-triangle me-2"></i>Defaulter Students
                    </h2>
                    <div class="d-flex gap-2 no-print">
                        <button class="btn btn-outline-success" id="printPdfBtn"><i class="fas fa-file-pdf me-2"></i>Print</button>
                        <button id="themeToggle" class="btn btn-outline-secondary theme-toggle"><i class="fas fa-moon"></i></button>
                    </div>
                </div>
            </div>
        </div>

        <div class="row justify-content-center">
            <div class="col-lg-12">
                <div class="card shadow-sm mb-4">
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-striped table-hover">
                                <thead><tr><th>CRN</th><th>Name</th><th>Course</th><th>Contact</th><th>Status</th></tr></thead>
                                <tbody id="defaultersTable"><tr><td colspan="5" class="text-center"><i class="fas fa-spinner fa-spin me-2"></i>Loading...</td></tr></tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/3.5.28/jspdf.plugin.autotable.min.js"></script>
    <script>
        $(document).ready(function() {
            function initTheme() {
                const savedTheme = localStorage.getItem('theme') || 'light';
                $('html').attr('data-bs-theme', savedTheme);
                $('#themeToggle i').removeClass('fa-moon fa-sun').addClass(savedTheme === 'dark' ? 'fa-sun' : 'fa-moon');
            }
            $('#themeToggle').click(function() {
                const currentTheme = $('html').attr('data-bs-theme');
                const newTheme = currentTheme === 'dark' ? 'light' : 'dark';
                $('html').attr('data-bs-theme', newTheme);
                localStorage.setItem('theme', newTheme);
                $('#themeToggle i').removeClass('fa-moon fa-sun').addClass(newTheme === 'dark' ? 'fa-sun' : 'fa-moon');
            });
            initTheme();

            function loadDefaulters() {
                $.ajax({
                    url: 'DefaulterStudentsServlet',
                    type: 'POST',
                    dataType: 'json',
                    success: function(response) {
                        if (response.success && response.data.length > 0) {
                            let html = '';
                            response.data.forEach(function(d) {
                                html += '<tr><td>' + d.crn + '</td><td>' + d.studentName + '</td><td>' + d.course + '</td><td>' + d.contact + '</td><td><span class="defaulter-badge">' + d.status + '</span></td></tr>';
                            });
                            $('#defaultersTable').html(html);
                        } else {
                            $('#defaultersTable').html('<tr><td colspan="5" class="text-center">No defaulter students found</td></tr>');
                        }
                    },
                    error: function() { $('#defaultersTable').html('<tr><td colspan="5" class="text-center text-danger">Error loading data</td></tr>'); }
                });
            }
            loadDefaulters();

            $('#printPdfBtn').click(function() {
                const { jsPDF } = window.jspdf;
                const doc = new jsPDF('p', 'pt', 'a4');
                const logoUrl = 'logo2.jpg';
                const img = new Image();
                img.src = logoUrl;
                img.onload = function() {
                    const maxWidth = 100;
                    const ratio = maxWidth / img.width;
                    const logoWidth = maxWidth;
                    const logoHeight = img.height * ratio;
                    doc.addImage(img, 'PNG', 40, 20, logoWidth, logoHeight);
                    doc.setFontSize(18);
                    doc.setTextColor(40);
                    doc.setFont("helvetica", "bold");
                    doc.text("Defaulter Students", 40 + logoWidth + 20, 20 + (logoHeight / 2));
                    const now = new Date();
                    doc.setFontSize(10);
                    doc.setFont("helvetica", "normal");
                    doc.text("Generated on: " + now.toLocaleString(), 40 + logoWidth + 20, 20 + (logoHeight / 2) + 20);
                    doc.setDrawColor(200,200,200);
                    doc.line(40, 20 + logoHeight + 20, doc.internal.pageSize.width - 40, 20 + logoHeight + 20);
                    const headers = ["CRN", "Student Name", "Course", "Contact", "Status"];
                    const data = [];
                    $('#defaultersTable tr').each(function() {
                        const rowData = [];
                        $(this).find('td').each(function() {
                            rowData.push($(this).text().trim());
                        });
                        if (rowData.length > 0 && rowData[0] !== 'No defaulter students found') data.push(rowData);
                    });
                    doc.autoTable({
                        startY: 20 + logoHeight + 40,
                        head: [headers],
                        body: data,
                        styles: { fontSize: 10, cellPadding: 4 },
                        headStyles: { fillColor: [231,74,59], textColor: 255, fontStyle: 'bold', halign: 'center' },
                        columnStyles: { 0: { halign: 'center' }, 4: { halign: 'center' } },
                        margin: { top: 20 + logoHeight + 40, left: 40, right: 40 },
                        didDrawPage: function(data) {
                            doc.setFontSize(10);
                            doc.setTextColor(150);
                            doc.text('Page ' + data.pageNumber + ' of ' + doc.internal.getNumberOfPages(), data.settings.margin.left, doc.internal.pageSize.height - 20);
                        }
                    });
                    doc.save("Defaulter_Students_" + new Date().toISOString().slice(0,10) + ".pdf");
                    Swal.fire({ icon: 'success', title: 'PDF Generated', text: 'Defaulter records exported', timer: 2000, showConfirmButton: false });
                };
                img.onerror = function() {
                    Swal.fire({ icon: 'error', title: 'Error', text: 'Logo not found. PDF generated without logo.' });
                };
            });
        });
    </script>
</body>
</html>