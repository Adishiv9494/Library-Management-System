<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en" data-bs-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/x-icon" href="logo2.jpg">
    <title>Return Books</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
    <style>
        :root {
            --primary-color: #4e73df;
            --success-color: #1cc88a;
            --warning-color: #f6c23e;
            --danger-color: #e74a3b;
            --info-color: #36b9cc;
        }
        
        [data-bs-theme="dark"] {
            --primary-color: #4e73df;
            --success-color: #1cc88a;
            --warning-color: #f6c23e;
            --danger-color: #e74a3b;
            --info-color: #36b9cc;
            --body-bg: #1a1a2e;
            --card-bg: #16213e;
            --text-color: #f8f9fa;
            --border-color: #2c3e50;
        }
        
        body {
            background-color: var(--body-bg, #f8f9fc);
            color: var(--text-color, #212529);
            transition: background-color 0.3s ease, color 0.3s ease;
        }
        
        .card {
            background-color: var(--card-bg, #ffffff);
            border-color: var(--border-color, #e3e6f0);
            transition: background-color 0.3s ease, border-color 0.3s ease;
        }
        
        .form-control, .input-group-text {
            background-color: var(--card-bg, #ffffff);
            color: var(--text-color, #212529);
            border-color: var(--border-color, #ced4da);
            transition: background-color 0.3s ease, color 0.3s ease, border-color 0.3s ease;
        }
        
        .card-status-pending { border-left: 5px solid var(--info-color); }
        .card-status-ondue { border-left: 5px solid var(--success-color); }
        .card-status-overdue { border-left: 5px solid var(--warning-color); }
        .card-status-defaulter { border-left: 5px solid var(--danger-color); }
        .card-status-returned { border-left: 5px solid #858796; }
        
        .status-badge {
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
            text-transform: uppercase;
            display: inline-block;
            text-align: center;
        }
        
        .status-issued { background-color: var(--success-color); color: white; }
        .status-overdue { background-color: var(--warning-color); color: #000; }
        .status-defaulter { background-color: var(--danger-color); color: white; }
        .status-returned { background-color: #858796; color: white; }
        
        .btn-renew {
            background-color: var(--warning-color);
            color: #000;
            border: none;
        }
        .btn-renew:hover { background-color: #dda20a; color: #000; }
        
        .fine-amount {
            color: var(--danger-color);
            font-weight: bold;
        }
        
        .detail-section {
            margin-bottom: 1.5rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid var(--border-color, #e3e6f0);
        }
        .detail-section:last-child { border-bottom: none; margin-bottom: 0; padding-bottom: 0; }
        .detail-section-title { font-weight: 600; margin-bottom: 0.75rem; color: var(--primary-color); }
        .detail-item { display: flex; margin-bottom: 0.5rem; }
        .detail-label { font-weight: 600; min-width: 120px; color: var(--text-color, #5a5c69); }
        .detail-value { flex-grow: 1; color: var(--text-color, #5a5c69); }
        
        .theme-toggle-btn {
            width: 40px; height: 40px;
            display: flex; align-items: center; justify-content: center;
            border-radius: 50%;
        }
    </style>
</head>
<body>
    <div class="container py-4">
        <div class="row mb-4">
            <div class="col-12">
                <div class="d-flex justify-content-between align-items-center">
                    <button class="btn btn-outline-primary" onclick="window.history.back()">
                        <i class="fas fa-arrow-left me-2"></i>Back
                    </button>
                    <h2 class="text-center mb-0 fw-bold" style="color: var(--primary-color);">
                        <i class="fas fa-book-return me-2"></i>Book Return
                    </h2>
                    <button id="themeToggle" class="btn btn-outline-secondary theme-toggle-btn">
                        <i class="fas fa-moon"></i>
                    </button>
                </div>
            </div>
        </div>

        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="card shadow-sm mb-4">
                    <div class="card-body">
                        <form id="returnForm">
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label">Student CRN</label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="fas fa-id-card"></i></span>
                                        <input type="text" class="form-control" id="crn" required autocomplete="off">
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Accession Number</label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="fas fa-barcode"></i></span>
                                        <input type="text" class="form-control" id="accessionNo" required autocomplete="off">
                                    </div>
                                </div>
                                <div class="col-12">
                                    <div class="d-flex justify-content-end gap-2">
                                        <button type="button" id="resetBtn" class="btn btn-outline-secondary">
                                            <i class="fas fa-undo me-2"></i>Reset
                                        </button>
                                        <button type="button" id="viewBtn" class="btn btn-primary">
                                            <i class="fas fa-eye me-2"></i>View Details
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

                <div class="card shadow-sm mb-4" id="resultCard" style="display:none;">
                    <div class="card-body">
                        <h4 class="card-title mb-4" style="color: var(--primary-color);">
                            <i class="fas fa-info-circle me-2"></i>Issue Details
                        </h4>
                        
                        <div class="issue-details-container">
                            <div class="detail-section">
                                <div class="detail-section-title"><i class="fas fa-user-graduate me-2"></i>Student Details</div>
                                <div class="detail-item"><span class="detail-label">Name:</span><span class="detail-value" id="studentName"></span></div>
                                <div class="detail-item"><span class="detail-label">Contact:</span><span class="detail-value" id="studentContact"></span></div>
                                <div class="detail-item"><span class="detail-label">Course:</span><span class="detail-value" id="studentCourse"></span></div>
                            </div>
                            
                            <div class="detail-section">
                                <div class="detail-section-title"><i class="fas fa-book me-2"></i>Book Details</div>
                                <div class="detail-item"><span class="detail-label">Title:</span><span class="detail-value" id="bookTitle"></span></div>
                                <div class="detail-item"><span class="detail-label">Author:</span><span class="detail-value" id="bookAuthor"></span></div>
                                <div class="detail-item"><span class="detail-label">Edition:</span><span class="detail-value" id="bookEdition"></span></div>
                            </div>
                            
                            <div class="detail-section">
                                <div class="detail-section-title"><i class="fas fa-calendar-alt me-2"></i>Issue Details</div>
                                <div class="detail-item"><span class="detail-label">Issue Date:</span><span class="detail-value" id="issueDate"></span></div>
                                <div class="detail-item"><span class="detail-label">Due Date:</span><span class="detail-value" id="dueDate"></span></div>
                                <div class="detail-item"><span class="detail-label">Status:</span><span class="detail-value" id="status"></span></div>
                                <div class="detail-item" id="fineContainer" style="display:none;"><span class="detail-label">Fine Amount:</span><span class="detail-value fine-amount" id="fineAmount"></span></div>
                                <div class="detail-item" id="daysOverdueContainer" style="display:none;"><span class="detail-label">Days Overdue:</span><span class="detail-value" id="daysOverdue"></span></div>
                            </div>
                            
                            <div class="due-date-picker" id="renewDateContainer" style="display:none;">
                                <label class="form-label"><i class="fas fa-calendar-plus me-2"></i>Select New Due Date</label>
                                <input type="date" class="form-control" id="renewDate" required>
                            </div>
                        </div>
                        
                        <div class="d-flex justify-content-end gap-2 mt-4" id="actionBtnContainer" style="display:none;">
                            <button type="button" id="renewBtn" class="btn btn-renew"><i class="fas fa-sync-alt me-2"></i>Renew Book</button>
                            <button type="button" id="returnBtn" class="btn btn-success"><i class="fas fa-check-circle me-2"></i>Submit Book</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

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

        $('#crn').on('input', function() {
            this.value = this.value.toUpperCase();
        });

        $('#viewBtn').click(function() {
            const crn = $('#crn').val().trim();
            const accessionNo = $('#accessionNo').val().trim();

            $('.is-invalid').removeClass('is-invalid');
            $('.invalid-feedback').remove();

            let isValid = true;
            if (!crn && !accessionNo) {
                Swal.fire({
                    icon: 'warning',
                    title: 'Missing Fields',
                    text: 'Please enter both Student CRN and Accession Number.',
                    confirmButtonColor: '#4e73df'
                });
                $('#crn, #accessionNo').addClass('is-invalid');
                return;
            }
            if (!crn) {
                $('#crn').addClass('is-invalid');
                $('#crn').after('<div class="invalid-feedback">CRN is required</div>');
                isValid = false;
            }
            if (!accessionNo) {
                $('#accessionNo').addClass('is-invalid');
                $('#accessionNo').after('<div class="invalid-feedback">Accession number is required</div>');
                isValid = false;
            }

            if (!isValid) return;

            const $viewBtn = $(this);
            $viewBtn.prop('disabled', true).html('<i class="fas fa-spinner fa-spin me-2"></i>Loading...');

            $.ajax({
                url: 'FetchReturnData',
                type: 'POST',
                data: { crn: crn, accessionNo: accessionNo },
                dataType: 'json',
                success: function(response) {
                    if (response.success) {
                        displayDetails(response);
                        $('#resultCard, #actionBtnContainer').fadeIn();
                    } else {
                        Swal.fire({ icon: 'error', title: 'Error', text: response.message || 'No record found' });
                        $('#resultCard').hide();
                    }
                },
                error: function() {
                    Swal.fire({ icon: 'error', title: 'Connection Error', text: 'Failed to fetch details.' });
                },
                complete: function() {
                    $viewBtn.prop('disabled', false).html('<i class="fas fa-eye me-2"></i>View Details');
                }
            });
        });

        function displayDetails(response) {
            const data = response.data;
            $('#studentName').text(data.student_name || 'N/A');
            $('#studentContact').text(data.contact || 'N/A');
            $('#studentCourse').text(data.course || 'N/A');
            $('#bookTitle').text(data.book_title || 'N/A');
            $('#bookAuthor').text(data.author || 'N/A');
            $('#bookEdition').text(data.edition || 'N/A');
            $('#issueDate').text(data.issue_date || 'N/A');
            $('#dueDate').text(data.due_date || 'N/A');
            
            // Status styling logic
            let rawStatus = (data.status || 'ISSUED').toUpperCase();
            let badgeClass = 'status-issued';
            let cardClass = 'card-status-ondue';
            
            if (rawStatus === 'OVERDUE') {
                badgeClass = 'status-overdue';
                cardClass = 'card-status-overdue';
            } else if (rawStatus === 'DEFAULTER') {
                badgeClass = 'status-defaulter';
                cardClass = 'card-status-defaulter';
            } else if (rawStatus === 'RETURNED') {
                badgeClass = 'status-returned';
                cardClass = 'card-status-returned';
            } else {
                rawStatus = 'ISSUED';
            }

            $('#status').html('<span class="status-badge ' + badgeClass + '">' + rawStatus + '</span>');
            $('#resultCard').removeClass('card-status-pending card-status-ondue card-status-overdue card-status-defaulter card-status-returned').addClass(cardClass);

            if (data.fine_amount > 0) {
                $('#fineAmount').text('₹' + parseFloat(data.fine_amount).toFixed(2));
                $('#fineContainer').show();
            } else {
                $('#fineContainer').hide();
            }

            if (data.days_overdue > 0) {
                $('#daysOverdue').text(data.days_overdue + ' days');
                $('#daysOverdueContainer').show();
            } else {
                $('#daysOverdueContainer').hide();
            }

            $('#resultCard').data('issueData', { issue_id: data.issue_id });
        }

        $('#returnBtn').click(function() {
            const issueData = $('#resultCard').data('issueData');

            if (!issueData || !issueData.issue_id) {
                Swal.fire({
                    icon: 'warning',
                    title: 'Action Required',
                    text: 'Please click "View Details" first.',
                    confirmButtonColor: '#4e73df'
                });
                return;
            }

            Swal.fire({
                title: 'Confirm Return',
                text: 'Are you sure you want to mark this book as returned?',
                icon: 'question',
                showCancelButton: true,
                confirmButtonColor: '#1cc88a',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Yes, return it!'
            }).then((result) => {
                if (result.isConfirmed) {
                    const $returnBtn = $(this);
                    $returnBtn.prop('disabled', true).html('<i class="fas fa-spinner fa-spin me-2"></i>Processing...');

                    $.ajax({
                        url: 'ReturnBook',
                        type: 'POST',
                        data: { issue_id: issueData.issue_id },
                        dataType: 'json',
                        success: function(response) {
                            if (response.success) {
                                Swal.fire({
                                    icon: 'success',
                                    title: 'Success!',
                                    text: response.message,
                                    confirmButtonColor: '#1cc88a'
                                }).then(() => {
                                    resetForm();
                                });
                            } else {
                                Swal.fire({ icon: 'error', title: 'Error', text: response.message });
                            }
                        },
                        error: function() {
                            Swal.fire({ icon: 'error', title: 'Error', text: 'Failed to process return request.' });
                        },
                        complete: function() {
                            $returnBtn.prop('disabled', false).html('<i class="fas fa-check-circle me-2"></i>Submit Book');
                        }
                    });
                }
            });
        });

        $('#resetBtn').click(function() {
            resetForm();
        });

        function resetForm() {
            $('#returnForm')[0].reset();
            $('#studentName, #studentContact, #studentCourse, #bookTitle, #bookAuthor, #bookEdition, #issueDate, #dueDate, #status, #fineAmount, #daysOverdue').text('');
            $('#resultCard, #renewDateContainer, #actionBtnContainer, #fineContainer, #daysOverdueContainer').hide();
            $('.is-invalid').removeClass('is-invalid');
            $('.invalid-feedback').remove();
            $('#resultCard').removeData('issueData');
            $('#crn').focus();
        }
    });
    </script>
</body>
</html>