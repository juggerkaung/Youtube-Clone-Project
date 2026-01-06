<!-- createPlaylist.jsp file: -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Create Playlist - YouTube Clone</title>
    <style>
        .create-playlist-container {
            max-width: 600px;
            margin: 20px auto;
            padding: 20px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        input[type="text"], textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 16px;
        }
        textarea {
            height: 100px;
            resize: vertical;
        }
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
        }
        .btn-primary {
            background: #065fd4;
            color: white;
        }
        .btn-secondary {
            background: #666;
            color: white;
        }
        .checkbox-group {
            display: flex;
            align-items: center;
            gap: 10px;
        }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />
    
    <div class="create-playlist-container">
        <h2>Create New Playlist</h2>
        
        <c:if test="${not empty param.error}">
            <div style="color: red; padding: 10px; background: #fff0f0; border: 1px solid #cc0000; border-radius: 4px; margin-bottom: 20px;">
                ${param.error}
            </div>
        </c:if>
        
        <form action="createPlaylist" method="post">
            <div class="form-group">
                <label for="name">Playlist Name:</label>
                <input type="text" id="name" name="name" required>
            </div>
            
            <div class="form-group">
                <label for="description">Description (optional):</label>
                <textarea id="description" name="description" placeholder="Describe your playlist..."></textarea>
            </div>
            
            <div class="form-group">
                <div class="checkbox-group">
                    <input type="checkbox" id="isPublic" name="isPublic" value="1" checked>
                    <label for="isPublic" style="display: inline; font-weight: normal;">
                        Make this playlist public
                    </label>
                </div>
                <small style="color: #666;">
                    • Public: Anyone can view this playlist<br>
                    • Private: Only you can view this playlist
                </small>
            </div>
            
            <div>
                <button type="submit" class="btn btn-primary">Create Playlist</button>
                <a href="playlists" class="btn btn-secondary" style="margin-left: 10px;">Cancel</a>
            </div>
        </form>
    </div>
</body>
</html>